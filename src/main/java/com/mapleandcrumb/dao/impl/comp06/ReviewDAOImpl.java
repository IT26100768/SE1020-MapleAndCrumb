package com.mapleandcrumb.dao.impl.comp06;

import com.mapleandcrumb.dao.comp06.ReviewDAO;
import com.mapleandcrumb.model.comp06.Review;
import com.mapleandcrumb.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAOImpl implements ReviewDAO {

    private static final String BASE_SELECT_SQL =
            "SELECT r.*, u.user_code, u.username, p.product_code, p.name AS product_name "
                    + "FROM reviews r "
                    + "LEFT JOIN users u ON r.customer_id = u.user_id "
                    + "LEFT JOIN products p ON r.product_id = p.product_id ";

    @Override
    public void addReview(Review review) {
        if (review == null) return;

        try (Connection conn = DBUtil.getConnection()) {
            Integer customerIdInt = DBUtil.findUserIdByCodeOrId(conn, review.getCustomerId());
            Integer productIdInt = DBUtil.findProductIdByCodeOrId(conn, review.getProductId());

            String sql = "INSERT INTO reviews (review_code, customer_id, product_id, rating, comment) VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, review.getReviewId());
                if (customerIdInt != null) {
                    ps.setInt(2, customerIdInt);
                } else {
                    ps.setNull(2, Types.INTEGER);
                }
                if (productIdInt != null) {
                    ps.setInt(3, productIdInt);
                } else {
                    ps.setNull(3, Types.INTEGER);
                }
                ps.setInt(4, review.getRating());
                ps.setString(5, review.getComment());
                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next() && (review.getReviewId() == null || review.getReviewId().isEmpty())) {
                        review.setReviewId(String.valueOf(rs.getInt(1)));
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("ReviewDAOImpl: Error adding review: " + e.getMessage());
        }
    }

    @Override
    public List<Review> getReviewsByProduct(String productId) {
        if (productId == null || productId.trim().isEmpty()) return new ArrayList<>();

        Integer prodIdInt = null;
        try (Connection conn = DBUtil.getConnection()) {
            prodIdInt = DBUtil.findProductIdByCodeOrId(conn, productId);
        } catch (SQLException ignored) {
        }

        String sql = BASE_SELECT_SQL + "WHERE p.product_code = ? OR r.product_id = ? ORDER BY r.review_id DESC";
        return DBUtil.queryList(sql, this::mapRowToReview, productId.trim(), prodIdInt != null ? prodIdInt : -1);
    }

    @Override
    public List<Review> getAllReviews() {
        return DBUtil.queryList(BASE_SELECT_SQL + "ORDER BY r.review_id DESC", this::mapRowToReview);
    }

    @Override
    public void updateReview(Review review) {
        if (review == null || review.getReviewId() == null) return;
        Integer numId = parseInteger(review.getReviewId());
        String sql = "UPDATE reviews SET rating = ?, comment = ? WHERE review_id = ? OR review_code = ?";
        DBUtil.executeUpdate(sql, review.getRating(), review.getComment(), numId != null ? numId : -1, review.getReviewId().trim());
    }

    @Override
    public void deleteReview(String reviewId) {
        if (reviewId == null || reviewId.trim().isEmpty()) return;
        Integer numId = parseInteger(reviewId);
        String sql = "DELETE FROM reviews WHERE review_id = ? OR review_code = ?";
        DBUtil.executeUpdate(sql, numId != null ? numId : -1, reviewId.trim());
    }

    private Integer parseInteger(String val) {
        try {
            return Integer.parseInt(val.trim());
        } catch (Exception e) {
            return null;
        }
    }

    private Review mapRowToReview(ResultSet rs) throws SQLException {
        int reviewIdInt = rs.getInt("review_id");
        String reviewCode = rs.getString("review_code");
        String idToUse = (reviewCode != null && !reviewCode.trim().isEmpty()) ? reviewCode : String.valueOf(reviewIdInt);

        String userCode = rs.getString("user_code");
        String customerId = (userCode != null && !userCode.trim().isEmpty()) ? userCode : String.valueOf(rs.getInt("customer_id"));
        String customerName = rs.getString("username");
        if (customerName == null || customerName.trim().isEmpty()) {
            customerName = "Verified Customer";
        }

        String productCode = rs.getString("product_code");
        String productId = (productCode != null && !productCode.trim().isEmpty()) ? productCode : String.valueOf(rs.getInt("product_id"));
        String productName = rs.getString("product_name");
        if (productName == null || productName.trim().isEmpty()) {
            productName = "Bakery Item";
        }

        int rating = rs.getInt("rating");
        String comment = rs.getString("comment");

        Timestamp ts = null;
        try {
            ts = rs.getTimestamp("created_at");
        } catch (SQLException ignored) {
        }
        LocalDateTime reviewDate = ts != null ? ts.toLocalDateTime() : LocalDateTime.now();

        return new Review(idToUse, customerId, customerName, productId, productName, rating, comment, reviewDate);
    }
}
