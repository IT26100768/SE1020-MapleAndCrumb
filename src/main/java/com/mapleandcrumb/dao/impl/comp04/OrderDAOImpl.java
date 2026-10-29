package com.mapleandcrumb.dao.impl.comp04;

import com.mapleandcrumb.dao.comp04.OrderDAO;
import com.mapleandcrumb.model.comp04.DeliveryOrder;
import com.mapleandcrumb.model.comp04.Order;
import com.mapleandcrumb.model.comp04.OrderItem;
import com.mapleandcrumb.model.comp04.PickupOrder;
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
import java.util.LinkedHashMap;
import java.util.Map;


public class OrderDAOImpl implements OrderDAO {

    private static final String BASE_SELECT_SQL =
            "SELECT o.*, u.user_code FROM orders o "
                    + "JOIN users u ON o.customer_id = u.user_id ";

    @Override
    public void createOrder(Order order) {
        if (order == null) return;

        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);
            try {
                Integer customerIdInt = DBUtil.findUserIdByCodeOrId(conn, order.getCustomerId());
                if (customerIdInt == null) {
                    System.err.println("OrderDAOImpl: Customer not found for identifier: " + order.getCustomerId());
                    conn.rollback();
                    return;
                }

                String orderType = (order instanceof DeliveryOrder) ? "Delivery" : "Pickup";
                String deliveryAddress = (order instanceof DeliveryOrder) ? ((DeliveryOrder) order).getDeliveryAddress() : null;
                double totalAmount = order.calculateFinalTotal();

                String insertOrderSql = "INSERT INTO orders (order_code, customer_id, total_amount, status, delivery_date, is_custom_order, order_type, delivery_address) "
                        + "VALUES (?, ?, ?, ?, ?, FALSE, ?, ?)";
                int generatedOrderId = 0;
                try (PreparedStatement psOrder = conn.prepareStatement(insertOrderSql, Statement.RETURN_GENERATED_KEYS)) {
                    psOrder.setString(1, order.getOrderId());
                    psOrder.setInt(2, customerIdInt);
                    psOrder.setDouble(3, totalAmount);
                    psOrder.setString(4, order.getStatus() != null ? order.getStatus() : "Pending");
                    psOrder.setDate(5, Date.valueOf(LocalDate.now()));
                    psOrder.setString(6, orderType);
                    psOrder.setString(7, deliveryAddress);
                    psOrder.executeUpdate();

                    try (ResultSet rsOrder = psOrder.getGeneratedKeys()) {
                        if (rsOrder.next()) {
                            generatedOrderId = rsOrder.getInt(1);
                            if (order.getOrderId() == null || order.getOrderId().isEmpty()) {
                                order.setOrderId(String.valueOf(generatedOrderId));
                            }
                        }
                    }
                }

                if (generatedOrderId == 0) {
                    Integer existingId = findInternalOrderId(conn, order.getOrderId());
                    if (existingId != null) {
                        generatedOrderId = existingId;
                    }
                }

                if (order.getItems() != null && !order.getItems().isEmpty()) {
                    insertOrderItems(conn, generatedOrderId, order.getItems());
                }

                conn.commit();
            } catch (SQLException e) {
                DBUtil.rollbackQuietly(conn);
                System.err.println("OrderDAOImpl: Error creating order: " + e.getMessage());
            } finally {
                try {
                    conn.setAutoCommit(true);
                } catch (SQLException ignored) {
                }
            }
        } catch (SQLException e) {
            System.err.println("OrderDAOImpl: Connection error on createOrder: " + e.getMessage());
        }
    }

    @Override
    public Order getOrderById(String orderId) {
        if (orderId == null || orderId.trim().isEmpty()) return null;
        Integer numId = parseInteger(orderId);
        String sql = (numId != null)
                ? BASE_SELECT_SQL + "WHERE o.order_id = ? OR o.order_code = ?"
                : BASE_SELECT_SQL + "WHERE o.order_code = ?";

        Order order = (numId != null)
                ? DBUtil.querySingle(sql, this::mapRowToOrderBase, numId, orderId.trim())
                : DBUtil.querySingle(sql, this::mapRowToOrderBase, orderId.trim());

        if (order != null) {
            try (Connection conn = DBUtil.getConnection()) {
                Integer internalId = findInternalOrderId(conn, order.getOrderId());
                if (internalId != null) {
                    loadOrderItems(conn, order, internalId);
                }
            } catch (SQLException ignored) {
            }
        }
        return order;
    }

    @Override
    public List<Order> getOrdersByCustomer(String customerId) {
        if (customerId == null || customerId.trim().isEmpty()) return new ArrayList<>();
        Integer customerIdInt = null;
        try (Connection conn = DBUtil.getConnection()) {
            customerIdInt = DBUtil.findUserIdByCodeOrId(conn, customerId);
        } catch (SQLException ignored) {
        }

        String sql = BASE_SELECT_SQL + "WHERE u.user_code = ? OR o.customer_id = ? OR u.email = ? ORDER BY o.order_id DESC";
        List<Order> list = DBUtil.queryList(sql, this::mapRowToOrderBase, customerId.trim(),
                customerIdInt != null ? customerIdInt : -1, customerId.trim());

        enrichOrdersWithItems(list);
        return list;
    }

    @Override
    public List<Order> getAllOrders() {
        List<Order> list = DBUtil.queryList(BASE_SELECT_SQL + "ORDER BY o.order_id DESC", this::mapRowToOrderBase);
        enrichOrdersWithItems(list);
        return list;
    }

    @Override
    public int getOrderCount() {
        return DBUtil.queryCount("SELECT COUNT(*) FROM orders");
    }

    @Override
    public void updateOrder(Order order) {
        if (order == null || order.getOrderId() == null) return;

        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);
            try {
                Integer internalOrderId = findInternalOrderId(conn, order.getOrderId());
                if (internalOrderId == null) {
                    conn.rollback();
                    return;
                }

                String orderType = (order instanceof DeliveryOrder) ? "Delivery" : "Pickup";
                String deliveryAddress = (order instanceof DeliveryOrder) ? ((DeliveryOrder) order).getDeliveryAddress() : null;
                double totalAmount = order.calculateFinalTotal();

                String sqlUpdate = "UPDATE orders SET total_amount = ?, status = ?, order_type = ?, delivery_address = ? WHERE order_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(sqlUpdate)) {
                    ps.setDouble(1, totalAmount);
                    ps.setString(2, order.getStatus());
                    ps.setString(3, orderType);
                    ps.setString(4, deliveryAddress);
                    ps.setInt(5, internalOrderId);
                    ps.executeUpdate();
                }

                try (PreparedStatement psDel = conn.prepareStatement("DELETE FROM order_items WHERE order_id = ?")) {
                    psDel.setInt(1, internalOrderId);
                    psDel.executeUpdate();
                }

                if (order.getItems() != null && !order.getItems().isEmpty()) {
                    insertOrderItems(conn, internalOrderId, order.getItems());
                }

                conn.commit();
            } catch (SQLException e) {
                DBUtil.rollbackQuietly(conn);
                System.err.println("OrderDAOImpl: Error updating order: " + e.getMessage());
            } finally {
                try {
                    conn.setAutoCommit(true);
                } catch (SQLException ignored) {
                }
            }
        } catch (SQLException e) {
            System.err.println("OrderDAOImpl: Connection error on updateOrder: " + e.getMessage());
        }
    }

    @Override
    public void updateOrderStatus(String orderId, String newStatus) {
        if (orderId == null || orderId.trim().isEmpty()) return;
        Integer numId = parseInteger(orderId);
        String sql = "UPDATE orders SET status = ? WHERE order_id = ? OR order_code = ?";
        DBUtil.executeUpdate(sql, newStatus, numId != null ? numId : -1, orderId.trim());
    }

    @Override
    public void cancelOrder(String orderId) {
        updateOrderStatus(orderId, "Cancelled");
        if (orderId == null || orderId.trim().isEmpty()) return;
        try (Connection conn = DBUtil.getConnection()) {
            Integer internalOrderId = findInternalOrderId(conn, orderId);
            if (internalOrderId != null) {
                DBUtil.executeUpdate("UPDATE payments SET status = 'REFUNDED' WHERE order_id = ?", internalOrderId);
            }
        } catch (SQLException ignored) {
        }
    }

    @Override
    public void recordPayment(String orderId, double amount, String paymentMethod, String status) {
        if (orderId == null || orderId.trim().isEmpty()) return;
        try (Connection conn = DBUtil.getConnection()) {
            Integer internalOrderId = findInternalOrderId(conn, orderId);
            if (internalOrderId != null) {
                String method = (paymentMethod != null && !paymentMethod.trim().isEmpty()) ? paymentMethod : "CARD_SIMULATED";
                String stat = (status != null && !status.trim().isEmpty()) ? status : "COMPLETED";
                DBUtil.executeUpdate("INSERT INTO payments (order_id, amount, payment_method, status) VALUES (?, ?, ?, ?)",
                        internalOrderId, amount, method, stat);
            }
        } catch (SQLException ignored) {
        }
    }

    @Override
    public String getPaymentMethod(String orderId) {
        if (orderId == null || orderId.trim().isEmpty()) return "Simulated Payment";
        try (Connection conn = DBUtil.getConnection()) {
            Integer internalOrderId = findInternalOrderId(conn, orderId);
            if (internalOrderId != null) {
                String method = DBUtil.querySingle(
                        "SELECT payment_method FROM payments WHERE order_id = ? ORDER BY payment_id DESC LIMIT 1",
                        rs -> rs.getString("payment_method"), internalOrderId);
                if (method != null) return method;
            }
        } catch (SQLException ignored) {
        }
        return "Simulated Payment";
    }

    private void insertOrderItems(Connection conn, int orderId, List<OrderItem> items) throws SQLException {
        String insertItemSql = "INSERT INTO order_items (order_id, product_id, product_name, quantity, unit_price, subtotal) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement psItem = conn.prepareStatement(insertItemSql)) {
            for (OrderItem item : items) {
                Integer prodId = DBUtil.findProductIdByCodeOrId(conn, item.getProductId());
                psItem.setInt(1, orderId);
                if (prodId != null) {
                    psItem.setInt(2, prodId);
                } else {
                    psItem.setNull(2, Types.INTEGER);
                }
                psItem.setString(3, item.getProductName());
                psItem.setInt(4, item.getQuantity());
                psItem.setDouble(5, item.getUnitPrice());
                psItem.setDouble(6, item.getSubtotal());
                psItem.addBatch();
            }
            psItem.executeBatch();
        }
    }

    private void enrichOrdersWithItems(List<Order> list) {
        if (list == null || list.isEmpty()) return;
        try (Connection conn = DBUtil.getConnection()) {
            for (Order order : list) {
                Integer internalId = findInternalOrderId(conn, order.getOrderId());
                if (internalId != null) {
                    loadOrderItems(conn, order, internalId);
                }
            }
        } catch (SQLException ignored) {
        }
    }

    private Integer parseInteger(String val) {
        try {
            return Integer.parseInt(val.trim());
        } catch (Exception e) {
            return null;
        }
    }

    private Order mapRowToOrderBase(ResultSet rs) throws SQLException {
        int orderIdInt = rs.getInt("order_id");
        String orderCode = rs.getString("order_code");
        String idToUse = (orderCode != null && !orderCode.trim().isEmpty()) ? orderCode : String.valueOf(orderIdInt);

        String userCode = rs.getString("user_code");
        String customerId = (userCode != null && !userCode.trim().isEmpty()) ? userCode : String.valueOf(rs.getInt("customer_id"));

        String orderType = rs.getString("order_type");
        String deliveryAddress = rs.getString("delivery_address");
        String status = rs.getString("status");

        Order order = "Delivery".equalsIgnoreCase(orderType)
                ? new DeliveryOrder(idToUse, customerId, deliveryAddress != null ? deliveryAddress : "N/A")
                : new PickupOrder(idToUse, customerId);
        order.setStatus(status != null ? status : "Pending");
        return order;
    }

    private void loadOrderItems(Connection conn, Order order, int internalOrderId) {
        String sql = "SELECT oi.*, p.product_code FROM order_items oi "
                + "LEFT JOIN products p ON oi.product_id = p.product_id "
                + "WHERE oi.order_id = ? "
                + "ORDER BY oi.order_item_id ASC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, internalOrderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String productCode = rs.getString("product_code");
                    int prodIdInt = rs.getInt("product_id");
                    String prodIdStr = (productCode != null && !productCode.isEmpty()) ? productCode : String.valueOf(prodIdInt);
                    String prodName = rs.getString("product_name");
                    int qty = rs.getInt("quantity");
                    double unitPrice = rs.getDouble("unit_price");
                    order.addItem(new OrderItem(prodIdStr, prodName, qty, unitPrice));
                }
            }
        } catch (SQLException e) {
            System.err.println("OrderDAOImpl: Error loading order items for order " + internalOrderId + ": " + e.getMessage());
        }
    }

    private Integer findInternalOrderId(Connection conn, String orderIdentifier) {
        return DBUtil.findOrderIdByCodeOrId(conn, orderIdentifier);
    }

    @Override
    public double getTodayRevenue() {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE DATE(order_date) = CURRENT_DATE() AND status != 'Cancelled'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            System.err.println("OrderDAOImpl.getTodayRevenue error: " + e.getMessage());
        }
        return 0.0;
    }

    @Override
    public double getYesterdayRevenue() {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE DATE(order_date) = DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY) AND status != 'Cancelled'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            System.err.println("OrderDAOImpl.getYesterdayRevenue error: " + e.getMessage());
        }
        return 0.0;
    }

    @Override
    public int getTodayOrderCount() {
        return DBUtil.queryCount("SELECT COUNT(*) FROM orders WHERE DATE(order_date) = CURRENT_DATE() AND status != 'Cancelled'");
    }

    @Override
    public int getTodayOrderCountByType(String orderType) {
        return DBUtil.queryCount("SELECT COUNT(*) FROM orders WHERE DATE(order_date) = CURRENT_DATE() AND status != 'Cancelled' AND LOWER(order_type) = LOWER(?)", orderType);
    }

    @Override
    public Map<String, Double> getDailyRevenueLast7Days() {
        Map<String, Double> result = new LinkedHashMap<>();
        LocalDate today = LocalDate.now();
        for (int i = 6; i >= 0; i--) {
            LocalDate d = today.minusDays(i);
            result.put(d.toString(), 0.0);
        }
        String sql = "SELECT DATE(order_date) AS odate, COALESCE(SUM(total_amount), 0) AS daily_sum "
                + "FROM orders "
                + "WHERE order_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 6 DAY) AND status != 'Cancelled' "
                + "GROUP BY DATE(order_date) ORDER BY odate ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String odate = rs.getString("odate");
                if (odate != null && result.containsKey(odate)) {
                    result.put(odate, rs.getDouble("daily_sum"));
                }
            }
        } catch (SQLException e) {
            System.err.println("OrderDAOImpl.getDailyRevenueLast7Days error: " + e.getMessage());
        }
        return result;
    }
}