package com.mapleandcrumb.dao.impl.comp06;

import com.mapleandcrumb.dao.comp06.PromotionDAO;
import com.mapleandcrumb.model.comp06.FixedAmountDiscount;
import com.mapleandcrumb.model.comp06.PercentageDiscount;
import com.mapleandcrumb.model.comp06.Promotion;
import com.mapleandcrumb.util.DBUtil;

import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

public class PromotionDAOImpl implements PromotionDAO {

    @Override
    public void addPromotionByCode(String promoCode) {
        addPromotion(new PercentageDiscount(promoCode, "Standard Discount", LocalDate.now().plusMonths(1), 10.0));
    }

    @Override
    public void addPromotion(Promotion promotion) {
        if (promotion == null) return;
        Object[] tv = extractTypeAndValue(promotion);
        LocalDate expiry = promotion.getExpiryDate() != null ? promotion.getExpiryDate() : LocalDate.now().plusMonths(1);
        String sql = "INSERT INTO promotions (promo_code, description, expiry_date, discount_type, discount_value) "
                + "VALUES (?, ?, ?, ?, ?) "
                + "ON DUPLICATE KEY UPDATE "
                + "description = VALUES(description), "
                + "expiry_date = VALUES(expiry_date), "
                + "discount_type = VALUES(discount_type), "
                + "discount_value = VALUES(discount_value)";
        DBUtil.executeUpdate(sql, promotion.getPromoCode(), promotion.getDescription(), expiry, tv[0], tv[1]);
    }

    @Override
    public List<Promotion> getAllActivePromotions() {
        return DBUtil.queryList("SELECT * FROM promotions WHERE expiry_date >= CURRENT_DATE() ORDER BY expiry_date ASC",
                this::mapRowToPromotion);
    }

    @Override
    public List<Promotion> getAllPromotions() {
        return DBUtil.queryList("SELECT * FROM promotions ORDER BY expiry_date ASC", this::mapRowToPromotion);
    }

    @Override
    public Promotion getPromotionByCode(String promoCode) {
        if (promoCode == null || promoCode.trim().isEmpty()) return null;
        return DBUtil.querySingle("SELECT * FROM promotions WHERE LOWER(promo_code) = LOWER(?)",
                this::mapRowToPromotion, promoCode.trim());
    }

    @Override
    public void updatePromotion(Promotion promotion) {
        if (promotion == null) return;
        Object[] tv = extractTypeAndValue(promotion);
        LocalDate expiry = promotion.getExpiryDate() != null ? promotion.getExpiryDate() : LocalDate.now().plusMonths(1);
        String sql = "UPDATE promotions SET description = ?, expiry_date = ?, discount_type = ?, discount_value = ? WHERE promo_code = ?";
        DBUtil.executeUpdate(sql, promotion.getDescription(), expiry, tv[0], tv[1], promotion.getPromoCode());
    }

    @Override
    public void deletePromotion(String promoCode) {
        if (promoCode == null || promoCode.trim().isEmpty()) return;
        DBUtil.executeUpdate("DELETE FROM promotions WHERE promo_code = ?", promoCode.trim());
    }

    private Object[] extractTypeAndValue(Promotion promotion) {
        if (promotion instanceof PercentageDiscount) {
            return new Object[]{"PERCENTAGE", ((PercentageDiscount) promotion).getPercentage()};
        } else if (promotion instanceof FixedAmountDiscount) {
            return new Object[]{"FIXED", ((FixedAmountDiscount) promotion).getFixedAmount()};
        }
        return new Object[]{"FIXED", 100.0 - promotion.applyDiscount(100.0)};
    }

    private Promotion mapRowToPromotion(ResultSet rs) throws SQLException {
        String code = rs.getString("promo_code");
        String desc = rs.getString("description");
        Date expDate = rs.getDate("expiry_date");
        LocalDate expiry = expDate != null ? expDate.toLocalDate() : LocalDate.now().plusMonths(1);
        String type = rs.getString("discount_type");
        double value = rs.getDouble("discount_value");

        return "PERCENTAGE".equalsIgnoreCase(type)
                ? new PercentageDiscount(code, desc, expiry, value)
                : new FixedAmountDiscount(code, desc, expiry, value);
    }
}
