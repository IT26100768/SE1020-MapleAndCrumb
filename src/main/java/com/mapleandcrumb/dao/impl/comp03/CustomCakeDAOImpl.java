package com.mapleandcrumb.dao.impl.comp03;

import com.mapleandcrumb.dao.comp03.CustomCakeDAO;
import com.mapleandcrumb.model.comp03.CustomCakeOrder;
import com.mapleandcrumb.util.DBUtil;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class CustomCakeDAOImpl implements CustomCakeDAO {

    private static final String BASE_SELECT_SQL =
            "SELECT c.*, u.user_code FROM custom_cake_requests c "
                    + "JOIN users u ON c.customer_id = u.user_id ";

    @Override
    public void createBooking(CustomCakeOrder booking) {
        if (booking == null) return;

        try (Connection conn = DBUtil.getConnection()) {
            Integer customerIdInt = DBUtil.findUserIdByCodeOrId(conn, booking.getCustomerId());
            if (customerIdInt == null) {
                System.err.println("CustomCakeDAOImpl: Customer not found for identifier: " + booking.getCustomerId());
                return;
            }

            String sql = "INSERT INTO custom_cake_requests (booking_code, customer_id, flavor, size, design_details, quoted_price, pickup_date, status) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, booking.getBookingId());
                ps.setInt(2, customerIdInt);
                ps.setString(3, booking.getFlavor());
                ps.setString(4, String.valueOf(booking.getSizeInches()));
                ps.setString(5, booking.getCustomMessage());
                ps.setDouble(6, booking.getQuotedPrice());
                if (booking.getPickupDate() != null) {
                    ps.setDate(7, Date.valueOf(booking.getPickupDate()));
                } else {
                    ps.setNull(7, Types.DATE);
                }
                ps.setString(8, booking.getStatus() != null ? booking.getStatus() : "Pending");
                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next() && (booking.getBookingId() == null || booking.getBookingId().isEmpty())) {
                        booking.setBookingId(String.valueOf(rs.getInt(1)));
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("CustomCakeDAOImpl: Error creating booking: " + e.getMessage());
        }
    }

    @Override
    public CustomCakeOrder getBookingById(String bookingId) {
        if (bookingId == null || bookingId.trim().isEmpty()) return null;
        Integer numId = parseInteger(bookingId);
        String sql = (numId != null)
                ? BASE_SELECT_SQL + "WHERE c.request_id = ? OR c.booking_code = ?"
                : BASE_SELECT_SQL + "WHERE c.booking_code = ?";
        return (numId != null)
                ? DBUtil.querySingle(sql, this::mapRowToBooking, numId, bookingId.trim())
                : DBUtil.querySingle(sql, this::mapRowToBooking, bookingId.trim());
    }

    @Override
    public List<CustomCakeOrder> getBookingsByCustomer(String customerId) {
        if (customerId == null || customerId.trim().isEmpty()) return new ArrayList<>();
        Integer customerIdInt = null;
        try (Connection conn = DBUtil.getConnection()) {
            customerIdInt = DBUtil.findUserIdByCodeOrId(conn, customerId);
        } catch (SQLException ignored) {
        }

        String sql = BASE_SELECT_SQL + "WHERE u.user_code = ? OR c.customer_id = ? OR u.email = ? ORDER BY c.request_id DESC";
        return DBUtil.queryList(sql, this::mapRowToBooking, customerId.trim(), customerIdInt != null ? customerIdInt : -1, customerId.trim());
    }

    @Override
    public List<CustomCakeOrder> getAllBookings() {
        return DBUtil.queryList(BASE_SELECT_SQL + "ORDER BY c.request_id DESC", this::mapRowToBooking);
    }

    @Override
    public int getBookingCount() {
        return DBUtil.queryCount("SELECT COUNT(*) FROM custom_cake_requests");
    }

    @Override
    public void updateBooking(CustomCakeOrder booking) {
        if (booking == null || booking.getBookingId() == null) return;
        Integer numId = parseInteger(booking.getBookingId());
        String sql = "UPDATE custom_cake_requests SET flavor = ?, size = ?, design_details = ?, quoted_price = ?, pickup_date = ?, status = ? "
                + "WHERE request_id = ? OR booking_code = ?";
        DBUtil.executeUpdate(sql, booking.getFlavor(), String.valueOf(booking.getSizeInches()), booking.getCustomMessage(),
                booking.calculateBasePrice(), booking.getPickupDate(), booking.getStatus(),
                numId != null ? numId : -1, booking.getBookingId().trim());
    }

    @Override
    public void updateBookingStatus(String bookingId, String newStatus) {
        if (bookingId == null || bookingId.trim().isEmpty()) return;
        Integer numId = parseInteger(bookingId);
        String sql = "UPDATE custom_cake_requests SET status = ? WHERE request_id = ? OR booking_code = ?";
        DBUtil.executeUpdate(sql, newStatus, numId != null ? numId : -1, bookingId.trim());
    }

    @Override
    public void cancelBooking(String bookingId) {
        updateBookingStatus(bookingId, "Cancelled");
    }

    private Integer parseInteger(String val) {
        try {
            return Integer.parseInt(val.trim());
        } catch (Exception e) {
            return null;
        }
    }

    private CustomCakeOrder mapRowToBooking(ResultSet rs) throws SQLException {
        int requestId = rs.getInt("request_id");
        String bookingCode = rs.getString("booking_code");
        String idToUse = (bookingCode != null && !bookingCode.trim().isEmpty()) ? bookingCode : String.valueOf(requestId);

        String userCode = rs.getString("user_code");
        String customerId = (userCode != null && !userCode.trim().isEmpty()) ? userCode : String.valueOf(rs.getInt("customer_id"));

        Date pickupDateVal = rs.getDate("pickup_date");
        LocalDate pickupDate = pickupDateVal != null ? pickupDateVal.toLocalDate() : LocalDate.now().plusDays(3);

        CustomCakeOrder order = new CustomCakeOrder(idToUse, customerId, pickupDate);
        order.selectFlavor(rs.getString("flavor"));

        String sizeStr = rs.getString("size");
        int sizeInches = 8;
        if (sizeStr != null) {
            try {
                sizeInches = Integer.parseInt(sizeStr.replaceAll("[^0-9]", ""));
            } catch (NumberFormatException ignored) {
            }
        }
        order.selectSize(sizeInches);
        order.addCustomMessage(rs.getString("design_details"));
        order.setStatus(rs.getString("status"));
        return order;
    }
}