package com.mapleandcrumb.dao.impl.comp05;

import com.mapleandcrumb.dao.comp05.KitchenTaskDAO;
import com.mapleandcrumb.model.comp04.OrderItem;
import com.mapleandcrumb.model.comp05.KitchenTask;
import com.mapleandcrumb.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class KitchenTaskDAOImpl implements KitchenTaskDAO {

    private static final String BASE_SELECT_SQL = "SELECT kt.*, "
            + "       o.order_code, o.order_type, o.delivery_address, o.total_amount AS order_amount, "
            + "       u_order.username AS order_cust_name, u_order.phone AS order_cust_phone, u_order.email AS order_cust_email, "
            + "       c.booking_code, c.flavor AS cake_flavor, c.size AS cake_size, c.design_details, c.quoted_price, "
            + "       u_cake.username AS cake_cust_name, u_cake.phone AS cake_cust_phone, u_cake.email AS cake_cust_email, "
            + "       u_baker.username AS baker_username, u_baker.user_code AS baker_user_code "
            + "FROM kitchen_tasks kt "
            + "LEFT JOIN orders o ON kt.order_id = o.order_id "
            + "LEFT JOIN users u_order ON o.customer_id = u_order.user_id "
            + "LEFT JOIN custom_cake_requests c ON kt.custom_request_id = c.request_id "
            + "LEFT JOIN users u_cake ON c.customer_id = u_cake.user_id "
            + "LEFT JOIN users u_baker ON kt.assigned_baker_id = u_baker.user_id ";

    @Override
    public void createTask(KitchenTask task) {
        if (task == null) return;

        String sql = "INSERT INTO kitchen_tasks (task_type, order_id, custom_request_id, assigned_baker_id, prep_stage, due_datetime, time_slot, priority, kitchen_notes) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, task.getTaskType());
            if (task.getOrderId() != null) ps.setInt(2, task.getOrderId()); else ps.setNull(2, Types.INTEGER);
            if (task.getCustomRequestId() != null) ps.setInt(3, task.getCustomRequestId()); else ps.setNull(3, Types.INTEGER);
            if (task.getAssignedBakerId() != null) ps.setInt(4, task.getAssignedBakerId()); else ps.setNull(4, Types.INTEGER);
            ps.setString(5, task.getPrepStage() != null ? task.getPrepStage() : "PENDING");
            ps.setTimestamp(6, task.getDueDatetime() != null ? Timestamp.valueOf(task.getDueDatetime())
                    : Timestamp.valueOf(LocalDateTime.now().plusHours(3)));
            ps.setString(7, task.getTimeSlot());
            ps.setString(8, task.getPriority() != null ? task.getPriority() : "NORMAL");
            ps.setString(9, task.getKitchenNotes());

            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    task.setTaskId(rs.getInt(1));
                }
            }
        } catch (SQLException e) {
            System.err.println("KitchenTaskDAOImpl: Error creating task: " + e.getMessage());
        }
    }

    @Override
    public KitchenTask getTaskById(int taskId) {
        KitchenTask task = DBUtil.querySingle(BASE_SELECT_SQL + "WHERE kt.task_id = ?", this::mapRowToTask, taskId);
        loadItemsForTask(task);
        return task;
    }

    @Override
    public KitchenTask getTaskByOrderId(int orderId) {
        KitchenTask task = DBUtil.querySingle(BASE_SELECT_SQL + "WHERE kt.order_id = ? ORDER BY kt.task_id DESC LIMIT 1",
                this::mapRowToTask, orderId);
        loadItemsForTask(task);
        return task;
    }

    @Override
    public KitchenTask getTaskByCustomRequestId(int customRequestId) {
        KitchenTask task = DBUtil.querySingle(BASE_SELECT_SQL + "WHERE kt.custom_request_id = ? ORDER BY kt.task_id DESC LIMIT 1",
                this::mapRowToTask, customRequestId);
        loadItemsForTask(task);
        return task;
    }

    @Override
    public List<KitchenTask> getAllActiveTasks() {
        syncMissingTasks();
        return getTasksByFilter("all", "all", "all", null);
    }

    @Override
    public List<KitchenTask> getTasksByFilter(String dateFilter, String channelFilter, String stageFilter,
                                              String searchKeyword) {
        syncMissingTasks();
        List<KitchenTask> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(BASE_SELECT_SQL);
        sql.append("WHERE kt.prep_stage != 'CANCELLED' ");

        if (stageFilter != null && !stageFilter.trim().isEmpty() && !"all".equalsIgnoreCase(stageFilter)) {
            if ("pending".equalsIgnoreCase(stageFilter)) {
                sql.append("AND kt.prep_stage = 'PENDING' ");
            } else if ("in_prep".equalsIgnoreCase(stageFilter) || "in_preparation".equalsIgnoreCase(stageFilter)) {
                sql.append("AND kt.prep_stage = 'IN_PREPARATION' ");
            } else if ("ready".equalsIgnoreCase(stageFilter) || "ready_for_pickup".equalsIgnoreCase(stageFilter)) {
                sql.append("AND kt.prep_stage = 'READY_FOR_PICKUP' ");
            } else if ("completed".equalsIgnoreCase(stageFilter)) {
                sql.append("AND kt.prep_stage = 'COMPLETED' ");
            }
        } else {
            sql.append("AND kt.prep_stage != 'COMPLETED' ");
        }

        if (dateFilter != null && !dateFilter.trim().isEmpty() && !"all".equalsIgnoreCase(dateFilter)) {
            if ("today".equalsIgnoreCase(dateFilter)) {
                sql.append("AND DATE(kt.due_datetime) = CURRENT_DATE() ");
            } else if ("tomorrow".equalsIgnoreCase(dateFilter)) {
                sql.append("AND DATE(kt.due_datetime) = DATE_ADD(CURRENT_DATE(), INTERVAL 1 DAY) ");
            } else if ("overdue".equalsIgnoreCase(dateFilter)) {
                sql.append("AND kt.due_datetime < NOW() AND kt.prep_stage NOT IN ('READY_FOR_PICKUP', 'COMPLETED') ");
            }
        }

        if (channelFilter != null && !channelFilter.trim().isEmpty() && !"all".equalsIgnoreCase(channelFilter)) {
            if ("delivery".equalsIgnoreCase(channelFilter)) {
                sql.append("AND (o.order_type = 'Delivery') ");
            } else if ("pickup".equalsIgnoreCase(channelFilter)) {
                sql.append("AND (o.order_type = 'Pickup' OR kt.task_type = 'CUSTOM_CAKE') ");
            }
        }

        boolean hasKeyword = searchKeyword != null && !searchKeyword.trim().isEmpty();
        if (hasKeyword) {
            sql.append("AND (o.order_code LIKE ? OR c.booking_code LIKE ? OR u_order.username LIKE ? OR u_cake.username LIKE ? OR kt.kitchen_notes LIKE ?) ");
        }

        sql.append("ORDER BY (kt.due_datetime < NOW() AND kt.prep_stage NOT IN ('READY_FOR_PICKUP', 'COMPLETED')) DESC, kt.due_datetime ASC, kt.task_id ASC");

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            if (hasKeyword) {
                String kw = "%" + searchKeyword.trim() + "%";
                for (int i = 1; i <= 5; i++) {
                    ps.setString(i, kw);
                }
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    KitchenTask task = mapRowToTask(rs);
                    loadTaskItems(conn, task);
                    list.add(task);
                }
            }
        } catch (SQLException e) {
            System.err.println("KitchenTaskDAOImpl: Error filtering tasks: " + e.getMessage());
        }
        return list;
    }

    @Override
    public void updatePrepStage(int taskId, String newStage) {
        if (newStage == null || newStage.trim().isEmpty()) return;
        String stageUpper = newStage.trim().toUpperCase();

        String sql = "UPDATE kitchen_tasks "
                + "SET prep_stage = ?, "
                + "    started_at = CASE WHEN ? = 'IN_PREPARATION' AND started_at IS NULL THEN CURRENT_TIMESTAMP ELSE started_at END, "
                + "    completed_at = CASE WHEN ? IN ('READY_FOR_PICKUP', 'COMPLETED') AND completed_at IS NULL THEN CURRENT_TIMESTAMP ELSE completed_at END "
                + "WHERE task_id = ?";

        DBUtil.executeUpdate(sql, stageUpper, stageUpper, stageUpper, taskId);

        KitchenTask current = getTaskById(taskId);
        if (current != null) {
            syncUpstreamStatus(current, stageUpper);
        }
    }

    @Override
    public void assignBaker(int taskId, Integer bakerUserId) {
        DBUtil.executeUpdate("UPDATE kitchen_tasks SET assigned_baker_id = ? WHERE task_id = ?",
                (bakerUserId != null && bakerUserId > 0) ? bakerUserId : null, taskId);
    }

    @Override
    public void updatePriority(int taskId, String newPriority) {
        if (newPriority == null || newPriority.trim().isEmpty()) return;
        DBUtil.executeUpdate("UPDATE kitchen_tasks SET priority = ? WHERE task_id = ?", newPriority.trim().toUpperCase(), taskId);
    }

    @Override
    public void cancelTaskBySource(String taskType, int sourceId) {
        if (taskType == null || sourceId <= 0) return;
        String col = "CUSTOM_CAKE".equalsIgnoreCase(taskType) ? "custom_request_id" : "order_id";
        DBUtil.executeUpdate("UPDATE kitchen_tasks SET prep_stage = 'CANCELLED' WHERE " + col + " = ?", sourceId);
    }

    @Override
    public int getActiveTaskCount() {
        syncMissingTasks();
        return DBUtil.queryCount("SELECT COUNT(*) FROM kitchen_tasks WHERE prep_stage NOT IN ('COMPLETED', 'CANCELLED')");
    }

    @Override
    public int getTodayTaskCount() {
        syncMissingTasks();
        return DBUtil.queryCount("SELECT COUNT(*) FROM kitchen_tasks WHERE DATE(due_datetime) = CURRENT_DATE() AND prep_stage NOT IN ('COMPLETED', 'CANCELLED')");
    }

    @Override
    public int getTomorrowTaskCount() {
        return DBUtil.queryCount("SELECT COUNT(*) FROM kitchen_tasks WHERE DATE(due_datetime) = DATE_ADD(CURRENT_DATE(), INTERVAL 1 DAY) AND prep_stage NOT IN ('COMPLETED', 'CANCELLED')");
    }

    @Override
    public int getCustomCakesInPrepCount() {
        return DBUtil.queryCount("SELECT COUNT(*) FROM kitchen_tasks WHERE task_type = 'CUSTOM_CAKE' AND prep_stage IN ('PENDING', 'IN_PREPARATION')");
    }

    @Override
    public int getOverdueTaskCount() {
        return DBUtil.queryCount("SELECT COUNT(*) FROM kitchen_tasks WHERE due_datetime < NOW() AND prep_stage NOT IN ('READY_FOR_PICKUP', 'COMPLETED', 'CANCELLED')");
    }

    @Override
    public void enqueueOrderTask(int orderId, String orderCode, LocalDateTime dueDateTime, String fulfillmentType,
                                 String notes) {
        if (orderId <= 0 && (orderCode == null || orderCode.trim().isEmpty())) return;
        if (orderId <= 0) orderId = resolveOrderId(orderCode);
        if (orderId <= 0) return;

        if (getTaskByOrderId(orderId) != null) return;

        KitchenTask task = new KitchenTask();
        task.setTaskType("ORDER");
        task.setOrderId(orderId);
        task.setOrderCode(orderCode);
        task.setFulfillmentType(fulfillmentType != null ? fulfillmentType : "Pickup");
        task.setDueDatetime(dueDateTime != null ? dueDateTime : LocalDateTime.now().plusHours(3));
        task.setTimeSlot("Standard Fulfillment Window");
        task.setPriority("NORMAL");
        task.setKitchenNotes(notes != null ? notes : "Pastry & Bread Batch Order");
        createTask(task);
    }

    @Override
    public void enqueueCakeTask(int customRequestId, String bookingCode, LocalDate pickupDate, String timeSlot,
                                String notes) {
        if (customRequestId <= 0 && (bookingCode == null || bookingCode.trim().isEmpty())) return;
        if (customRequestId <= 0) customRequestId = resolveCakeRequestId(bookingCode);
        if (customRequestId <= 0) return;

        if (getTaskByCustomRequestId(customRequestId) != null) return;

        KitchenTask task = new KitchenTask();
        task.setTaskType("CUSTOM_CAKE");
        task.setCustomRequestId(customRequestId);
        task.setBookingCode(bookingCode);
        task.setFulfillmentType("Pickup");
        task.setDueDatetime(pickupDate != null ? pickupDate.atTime(12, 0) : LocalDateTime.now().plusDays(2).withHour(12).withMinute(0));
        task.setTimeSlot(timeSlot != null ? timeSlot : "Pickup Slot: Morning (9:00 AM - 12:00 PM)");
        task.setPriority("HIGH");
        task.setKitchenNotes(notes != null ? notes : "Bespoke Celebration Cake");
        createTask(task);
    }

    @Override
    public void syncOrderStatus(String orderIdentifier, String newStatus) {
        if (orderIdentifier == null || orderIdentifier.trim().isEmpty() || newStatus == null) return;
        int orderId = resolveOrderId(orderIdentifier);
        if (orderId <= 0) return;

        String statusTrim = newStatus.trim();
        if ("Cancelled".equalsIgnoreCase(statusTrim)) {
            cancelTaskBySource("ORDER", orderId);
            return;
        }

        String mappedStage = "PENDING";
        if ("Completed".equalsIgnoreCase(statusTrim) || "Delivered".equalsIgnoreCase(statusTrim)) {
            mappedStage = "COMPLETED";
        } else if ("Ready for Pickup".equalsIgnoreCase(statusTrim) || "Out for Delivery".equalsIgnoreCase(statusTrim)) {
            mappedStage = "READY_FOR_PICKUP";
        } else if ("Processing".equalsIgnoreCase(statusTrim) || "In Preparation".equalsIgnoreCase(statusTrim)
                || "Baking".equalsIgnoreCase(statusTrim) || "Confirmed".equalsIgnoreCase(statusTrim)) {
            mappedStage = "IN_PREPARATION";
        }

        KitchenTask existing = getTaskByOrderId(orderId);
        if (existing != null) {
            updatePrepStage(existing.getTaskId(), mappedStage);
        }
    }

    @Override
    public void syncCakeStatus(String bookingIdentifier, String newStatus) {
        if (bookingIdentifier == null || bookingIdentifier.trim().isEmpty() || newStatus == null) return;
        int cakeId = resolveCakeRequestId(bookingIdentifier);
        if (cakeId <= 0) return;

        String statusTrim = newStatus.trim();
        if ("Cancelled".equalsIgnoreCase(statusTrim)) {
            cancelTaskBySource("CUSTOM_CAKE", cakeId);
            return;
        }

        String mappedStage = "PENDING";
        if ("Completed".equalsIgnoreCase(statusTrim)) {
            mappedStage = "COMPLETED";
        } else if ("Ready for Pickup".equalsIgnoreCase(statusTrim)) {
            mappedStage = "READY_FOR_PICKUP";
        } else if ("In Preparation".equalsIgnoreCase(statusTrim) || "Baking".equalsIgnoreCase(statusTrim)
                || "Confirmed".equalsIgnoreCase(statusTrim)) {
            mappedStage = "IN_PREPARATION";
        }

        KitchenTask existing = getTaskByCustomRequestId(cakeId);
        if (existing != null) {
            updatePrepStage(existing.getTaskId(), mappedStage);
        }
    }

    @Override
    public void syncMissingTasks() {
        String sqlOrderSync = "INSERT INTO kitchen_tasks (task_type, order_id, custom_request_id, assigned_baker_id, prep_stage, due_datetime, time_slot, priority, kitchen_notes) "
                + "SELECT 'ORDER', o.order_id, NULL, NULL, "
                + "       CASE "
                + "           WHEN o.status = 'Completed' THEN 'COMPLETED' "
                + "           WHEN o.status IN ('Ready for Pickup', 'Out for Delivery') THEN 'READY_FOR_PICKUP' "
                + "           WHEN o.status IN ('Processing', 'In Preparation') THEN 'IN_PREPARATION' "
                + "           ELSE 'PENDING' "
                + "       END, "
                + "       CASE "
                + "           WHEN o.delivery_date IS NOT NULL THEN CAST(CONCAT(o.delivery_date, ' 14:00:00') AS DATETIME) "
                + "           ELSE DATE_ADD(CURRENT_DATE(), INTERVAL 14 HOUR) "
                + "       END, "
                + "       'Standard Fulfillment Window', 'NORMAL', 'Pastry & Bread Order' "
                + "FROM orders o "
                + "WHERE o.status != 'Cancelled' "
                + "  AND NOT EXISTS (SELECT 1 FROM kitchen_tasks kt WHERE kt.order_id = o.order_id)";

        String sqlCakeSync = "INSERT INTO kitchen_tasks (task_type, order_id, custom_request_id, assigned_baker_id, prep_stage, due_datetime, time_slot, priority, kitchen_notes) "
                + "SELECT 'CUSTOM_CAKE', NULL, c.request_id, NULL, "
                + "       CASE "
                + "           WHEN c.status = 'Completed' THEN 'COMPLETED' "
                + "           WHEN c.status = 'Ready for Pickup' THEN 'READY_FOR_PICKUP' "
                + "           WHEN c.status IN ('Confirmed', 'In Preparation', 'Baking') THEN 'IN_PREPARATION' "
                + "           ELSE 'PENDING' "
                + "       END, "
                + "       CASE "
                + "           WHEN c.pickup_date IS NOT NULL THEN CAST(CONCAT(c.pickup_date, ' 12:00:00') AS DATETIME) "
                + "           ELSE DATE_ADD(CURRENT_DATE(), INTERVAL 12 HOUR) "
                + "       END, "
                + "       'Morning (9:00 AM - 12:00 PM)', 'HIGH', COALESCE(c.design_details, 'Custom Cake Order') "
                + "FROM custom_cake_requests c "
                + "WHERE c.status != 'Cancelled' "
                + "  AND NOT EXISTS (SELECT 1 FROM kitchen_tasks kt WHERE kt.custom_request_id = c.request_id)";

        DBUtil.executeUpdate(sqlOrderSync);
        DBUtil.executeUpdate(sqlCakeSync);
    }

    private int resolveOrderId(String orderIdentifier) {
        if (orderIdentifier == null || orderIdentifier.trim().isEmpty()) return -1;
        try (Connection conn = DBUtil.getConnection()) {
            Integer id = DBUtil.findOrderIdByCodeOrId(conn, orderIdentifier.trim());
            return id != null ? id : -1;
        } catch (SQLException e) {
            return -1;
        }
    }

    private int resolveCakeRequestId(String bookingIdentifier) {
        if (bookingIdentifier == null || bookingIdentifier.trim().isEmpty()) return -1;
        try (Connection conn = DBUtil.getConnection()) {
            Integer id = DBUtil.findCakeRequestIdByCodeOrId(conn, bookingIdentifier.trim());
            return id != null ? id : -1;
        } catch (SQLException e) {
            return -1;
        }
    }

    private void syncUpstreamStatus(KitchenTask task, String prepStage) {
        if ("ORDER".equals(task.getTaskType()) && task.getOrderId() != null) {
            String orderStatus = null;
            if ("COMPLETED".equals(prepStage)) orderStatus = "Completed";
            else if ("READY_FOR_PICKUP".equals(prepStage)) orderStatus = "Ready for Pickup";
            else if ("IN_PREPARATION".equals(prepStage)) orderStatus = "Processing";

            if (orderStatus != null) {
                DBUtil.executeUpdate("UPDATE orders SET status = ? WHERE order_id = ?", orderStatus, task.getOrderId());
            }
        } else if ("CUSTOM_CAKE".equals(task.getTaskType()) && task.getCustomRequestId() != null) {
            String cakeStatus = null;
            if ("COMPLETED".equals(prepStage)) cakeStatus = "Completed";
            else if ("READY_FOR_PICKUP".equals(prepStage)) cakeStatus = "Ready for Pickup";
            else if ("IN_PREPARATION".equals(prepStage)) cakeStatus = "In Preparation";

            if (cakeStatus != null) {
                DBUtil.executeUpdate("UPDATE custom_cake_requests SET status = ? WHERE request_id = ?", cakeStatus, task.getCustomRequestId());
            }
        }
    }

    private void loadItemsForTask(KitchenTask task) {
        if (task == null || !"ORDER".equalsIgnoreCase(task.getTaskType()) || task.getOrderId() == null) return;
        try (Connection conn = DBUtil.getConnection()) {
            loadTaskItems(conn, task);
        } catch (SQLException ignored) {
        }
    }

    private KitchenTask mapRowToTask(ResultSet rs) throws SQLException {
        KitchenTask task = new KitchenTask();
        task.setTaskId(rs.getInt("task_id"));
        task.setTaskType(rs.getString("task_type"));

        int orderIdVal = rs.getInt("order_id");
        if (!rs.wasNull()) task.setOrderId(orderIdVal);

        int cakeIdVal = rs.getInt("custom_request_id");
        if (!rs.wasNull()) task.setCustomRequestId(cakeIdVal);

        int bakerIdVal = rs.getInt("assigned_baker_id");
        if (!rs.wasNull()) task.setAssignedBakerId(bakerIdVal);

        task.setAssignedBakerName(rs.getString("baker_username"));
        task.setAssignedBakerUserCode(rs.getString("baker_user_code"));
        task.setPrepStage(rs.getString("prep_stage"));

        Timestamp dueTs = rs.getTimestamp("due_datetime");
        if (dueTs != null) task.setDueDatetime(dueTs.toLocalDateTime());

        task.setTimeSlot(rs.getString("time_slot"));
        task.setPriority(rs.getString("priority"));
        task.setKitchenNotes(rs.getString("kitchen_notes"));

        Timestamp createdTs = rs.getTimestamp("created_at");
        if (createdTs != null) task.setCreatedAt(createdTs.toLocalDateTime());

        Timestamp startedTs = rs.getTimestamp("started_at");
        if (startedTs != null) task.setStartedAt(startedTs.toLocalDateTime());

        Timestamp completedTs = rs.getTimestamp("completed_at");
        if (completedTs != null) task.setCompletedAt(completedTs.toLocalDateTime());

        if ("CUSTOM_CAKE".equalsIgnoreCase(task.getTaskType())) {
            task.setBookingCode(rs.getString("booking_code"));
            task.setCustomerName(rs.getString("cake_cust_name"));
            task.setCustomerPhone(rs.getString("cake_cust_phone"));
            task.setCustomerEmail(rs.getString("cake_cust_email"));
            task.setCustomCakeFlavor(rs.getString("cake_flavor"));
            String sizeStr = rs.getString("cake_size");
            int sizeInches = 8;
            if (sizeStr != null) {
                try {
                    sizeInches = Integer.parseInt(sizeStr.replaceAll("[^0-9]", ""));
                } catch (NumberFormatException ignored) {
                }
            }
            task.setCustomCakeSizeInches(sizeInches);
            task.setCustomCakeMessage(rs.getString("design_details"));
            task.setTotalAmount(rs.getDouble("quoted_price"));
            task.setFulfillmentType("Pickup");
        } else {
            task.setOrderCode(rs.getString("order_code"));
            task.setCustomerName(rs.getString("order_cust_name"));
            task.setCustomerPhone(rs.getString("order_cust_phone"));
            task.setCustomerEmail(rs.getString("order_cust_email"));
            task.setFulfillmentType(rs.getString("order_type"));
            task.setDeliveryAddress(rs.getString("delivery_address"));
            task.setTotalAmount(rs.getDouble("order_amount"));
        }

        return task;
    }

    private void loadTaskItems(Connection conn, KitchenTask task) {
        if (!"ORDER".equalsIgnoreCase(task.getTaskType()) || task.getOrderId() == null) {
            return;
        }

        String sql = "SELECT oi.*, p.product_code, p.contains_nuts FROM order_items oi "
                + "LEFT JOIN products p ON oi.product_id = p.product_id "
                + "WHERE oi.order_id = ? "
                + "ORDER BY oi.order_item_id ASC";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, task.getOrderId());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String productCode = rs.getString("product_code");
                    int prodIdInt = rs.getInt("product_id");
                    String prodIdStr = (productCode != null && !productCode.isEmpty()) ? productCode
                            : String.valueOf(prodIdInt);
                    String prodName = rs.getString("product_name");
                    int qty = rs.getInt("quantity");
                    double unitPrice = rs.getDouble("unit_price");

                    if (rs.getBoolean("contains_nuts")) {
                        task.setContainsNuts(true);
                    }
                    task.addItem(new OrderItem(prodIdStr, prodName, qty, unitPrice));
                }
            }
        } catch (SQLException e) {
            System.err.println("KitchenTaskDAOImpl: Error loading order items for task " + task.getTaskId() + ": " + e.getMessage());
        }
    }
}
