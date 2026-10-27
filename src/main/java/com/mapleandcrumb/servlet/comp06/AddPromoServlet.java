package com.mapleandcrumb.servlet.comp06;

import com.mapleandcrumb.dao.comp06.PromotionDAO;
import com.mapleandcrumb.dao.impl.comp06.PromotionDAOImpl;
import com.mapleandcrumb.model.comp06.FixedAmountDiscount;
import com.mapleandcrumb.model.comp06.PercentageDiscount;
import com.mapleandcrumb.model.comp06.Promotion;
import com.mapleandcrumb.util.ParamUtil;
import com.mapleandcrumb.util.SecurityUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.prefs.AbstractPreferences;

@WebServlet({ "/addPromo", "/managePromotions", "/manage_promotions", "/comp06-reviews/addPromo", "/comp06-reviews/manage_promotions", "/comp06-reviews/managePromotions", "/comp06-promotions/addPromo", "/comp06-promotions/manage_promotions" })
public class AddPromoServlet extends HttpServlet {

    private final PromotionDAO promotionDAO = new PromotionDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!SecurityUtil.requireStaffOrAdmin(request, response)) {
            return;
        }

        List<Promotion> promotions = promotionDAO.getAllPromotions();
        LocalDate today = LocalDate.now();

        int activeCount = 0;
        int expiredCount = 0;
        for (Promotion p : promotions) {
            if (p.getExpiryDate() != null && !p.getExpiryDate().isBefore(today)) {
                activeCount++;
            } else {
                expiredCount++;
            }
        }

        request.setAttribute("promotions", promotions);
        request.setAttribute("totalPromotions", promotions.size());
        request.setAttribute("activeCount", activeCount);
        request.setAttribute("expiredCount", expiredCount);

        request.getRequestDispatcher("/comp06-reviews/manage_promotions.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!SecurityUtil.requireStaffOrAdmin(request, response)) {
            return;
        }

        AbstractPreferences ParamUtil;
        String action = ParamUtil.getTrimmed(request, "action");
        if ("delete".equalsIgnoreCase(action)) {
            String promoCode = ParamUtil.getTrimmed(request, "promoCode");
            if (promoCode != null) {
                promotionDAO.deletePromotion(promoCode);
            }
            response.sendRedirect(request.getContextPath() + "/managePromotions?msg=deleted");
            return;
        }

        String promoCode = ParamUtil.getTrimmed(request, "promoCode");
        String description = ParamUtil.getTrimmed(request, "description");
        String discountType = ParamUtil.getTrimmed(request, "discountType");
        String expiryDateStr = ParamUtil.getTrimmed(request, "expiryDate");
        double discountValue = ParamUtil.getDouble(request, "discountValue", -1.0);

        if (promoCode == null || description == null || discountType == null || expiryDateStr == null || discountValue <= 0) {
            response.sendRedirect(request.getContextPath() + "/managePromotions?error=invalidValue");
            return;
        }

        promoCode = promoCode.toUpperCase().replaceAll("\\s+", "");
        discountType = discountType.toUpperCase();

        if ("PERCENTAGE".equals(discountType) && discountValue > 100.0) {
            response.sendRedirect(request.getContextPath() + "/managePromotions?error=percentageOverLimit");
            return;
        }

        LocalDate expiryDate;
        try {
            expiryDate = LocalDate.parse(expiryDateStr);
        } catch (DateTimeParseException e) {
            response.sendRedirect(request.getContextPath() + "/managePromotions?error=invalidDate");
            return;
        }

        //add promotion to database percentage or fixed amount

        Promotion promo = "PERCENTAGE".equals(discountType)
                ? new PercentageDiscount(promoCode, description, expiryDate, discountValue)
                : new FixedAmountDiscount(promoCode, description, expiryDate, discountValue);

        promotionDAO.addPromotion(promo);
        response.sendRedirect(request.getContextPath() + "/managePromotions?msg=created");
    }
}
