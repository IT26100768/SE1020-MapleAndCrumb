package com.mapleandcrumb.model.comp05;

import com.mapleandcrumb.model.comp04.OrderItem;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Encapsulates an active bakery operational task in the Production & Kitchen Queue.
 * Corresponds to table `kitchen_tasks` (Component 5).
 */
public class KitchenTask {

    private int taskId;
    private String taskType; // "ORDER" or "CUSTOM_CAKE"
    private Integer orderId;
    private String orderCode;
    private Integer customRequestId;
    private String bookingCode;
    private Integer assignedBakerId;
    private String assignedBakerUserCode;
    private String assignedBakerName;
    private String prepStage; // "PENDING", "IN_PREPARATION", "READY_FOR_PICKUP", "COMPLETED", "CANCELLED"
    private LocalDateTime dueDatetime;
    private String timeSlot;
    private String priority; // "NORMAL", "HIGH", "URGENT"
    private String kitchenNotes;
    private LocalDateTime createdAt;
    private LocalDateTime startedAt;
    private LocalDateTime completedAt;

    // Associated context fields for kitchen operations & ticket rendering
    private String customerName;
    private String customerPhone;
    private String customerEmail;
    private String fulfillmentType = "Pickup"; // "Pickup" or "Delivery"
    private String deliveryAddress;
    private List<OrderItem> items = new ArrayList<>();
    private String customCakeFlavor;
    private int customCakeSizeInches;
    private String customCakeMessage;
    private boolean containsNuts = false;
    private double totalAmount = 0.0;

    public KitchenTask() {
        this.prepStage = "PENDING";
        this.priority = "NORMAL";
        this.createdAt = LocalDateTime.now();
    }

    public KitchenTask(int taskId, String taskType, LocalDateTime dueDatetime, String priority) {
        this();
        this.taskId = taskId;
        this.taskType = taskType;
        this.dueDatetime = dueDatetime;
        this.priority = priority != null ? priority : "NORMAL";
    }

    public int getTaskId() {
        return taskId;
    }

    public void setTaskId(int taskId) {
        this.taskId = taskId;
    }

    public String getTaskType() {
        return taskType;
    }

    public void setTaskType(String taskType) {
        this.taskType = taskType;
    }

    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    public String getOrderCode() {
        return orderCode;
    }

    public void setOrderCode(String orderCode) {
        this.orderCode = orderCode;
    }

    public Integer getCustomRequestId() {
        return customRequestId;
    }

    public void setCustomRequestId(Integer customRequestId) {
        this.customRequestId = customRequestId;
    }

    public String getBookingCode() {
        return bookingCode;
    }

    public void setBookingCode(String bookingCode) {
        this.bookingCode = bookingCode;
    }

    public Integer getAssignedBakerId() {
        return assignedBakerId;
    }

    public void setAssignedBakerId(Integer assignedBakerId) {
        this.assignedBakerId = assignedBakerId;
    }

    public String getAssignedBakerUserCode() {
        return assignedBakerUserCode;
    }

    public void setAssignedBakerUserCode(String assignedBakerUserCode) {
        this.assignedBakerUserCode = assignedBakerUserCode;
    }

    public boolean isAssignedTo(String staffIdentifier) {
        if (staffIdentifier == null || (assignedBakerId == null && assignedBakerUserCode == null)) {
            return false;
        }
        String clean = staffIdentifier.trim();
        if (assignedBakerUserCode != null && assignedBakerUserCode.equalsIgnoreCase(clean)) {
            return true;
        }
        if (assignedBakerId != null && String.valueOf(assignedBakerId).equals(clean)) {
            return true;
        }
        return false;
    }

    public String getAssignedBakerName() {
        return assignedBakerName != null && !assignedBakerName.trim().isEmpty() ? assignedBakerName : "Unassigned";
    }

    public void setAssignedBakerName(String assignedBakerName) {
        this.assignedBakerName = assignedBakerName;
    }

    public String getPrepStage() {
        return prepStage != null ? prepStage : "PENDING";
    }

    public void setPrepStage(String prepStage) {
        this.prepStage = prepStage;
    }

    public LocalDateTime getDueDatetime() {
        return dueDatetime;
    }

    public void setDueDatetime(LocalDateTime dueDatetime) {
        this.dueDatetime = dueDatetime;
    }

    public String getTimeSlot() {
        return timeSlot;
    }

    public void setTimeSlot(String timeSlot) {
        this.timeSlot = timeSlot;
    }

    public String getPriority() {
        return priority != null ? priority : "NORMAL";
    }

    public void setPriority(String priority) {
        this.priority = priority;
    }

    public String getKitchenNotes() {
        return kitchenNotes;
    }

    public void setKitchenNotes(String kitchenNotes) {
        this.kitchenNotes = kitchenNotes;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getStartedAt() {
        return startedAt;
    }

    public void setStartedAt(LocalDateTime startedAt) {
        this.startedAt = startedAt;
    }

    public LocalDateTime getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(LocalDateTime completedAt) {
        this.completedAt = completedAt;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerPhone() {
        return customerPhone;
    }

    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }

    public String getCustomerEmail() {
        return customerEmail;
    }

    public void setCustomerEmail(String customerEmail) {
        this.customerEmail = customerEmail;
    }

    public String getFulfillmentType() {
        return fulfillmentType != null ? fulfillmentType : "Pickup";
    }

    public void setFulfillmentType(String fulfillmentType) {
        this.fulfillmentType = fulfillmentType;
    }

    public String getDeliveryAddress() {
        return deliveryAddress;
    }

    public void setDeliveryAddress(String deliveryAddress) {
        this.deliveryAddress = deliveryAddress;
    }

    public List<OrderItem> getItems() {
        return items;
    }

    public void setItems(List<OrderItem> items) {
        this.items = items;
    }

    public void addItem(OrderItem item) {
        if (this.items == null) {
            this.items = new ArrayList<>();
        }
        this.items.add(item);
    }

    public String getCustomCakeFlavor() {
        return customCakeFlavor;
    }

    public void setCustomCakeFlavor(String customCakeFlavor) {
        this.customCakeFlavor = customCakeFlavor;
    }

    public int getCustomCakeSizeInches() {
        return customCakeSizeInches;
    }

    public void setCustomCakeSizeInches(int customCakeSizeInches) {
        this.customCakeSizeInches = customCakeSizeInches;
    }

    public String getCustomCakeMessage() {
        return customCakeMessage;
    }

    public void setCustomCakeMessage(String customCakeMessage) {
        this.customCakeMessage = customCakeMessage;
    }

    public boolean isContainsNuts() {
        return containsNuts;
    }

    public void setContainsNuts(boolean containsNuts) {
        this.containsNuts = containsNuts;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    /**
     * Resolves the primary reference code (Order code or Cake Booking code).
     */
    public String getReferenceCode() {
        if ("CUSTOM_CAKE".equalsIgnoreCase(taskType)) {
            return bookingCode != null ? bookingCode : ("BK-" + (customRequestId != null ? customRequestId : taskId));
        } else {
            return orderCode != null ? orderCode : ("ORD-" + (orderId != null ? orderId : taskId));
        }
    }

    /**
     * Determines whether this task has exceeded its due deadline and is still in active preparation.
     */
    public boolean isOverdue() {
        if (dueDatetime == null) return false;
        if ("READY_FOR_PICKUP".equalsIgnoreCase(prepStage) ||
                "COMPLETED".equalsIgnoreCase(prepStage) ||
                "CANCELLED".equalsIgnoreCase(prepStage)) {
            return false;
        }
        return dueDatetime.isBefore(LocalDateTime.now());
    }

    /**
     * Checks if this task is due today.
     */
    public boolean isDueToday() {
        if (dueDatetime == null) return false;
        return dueDatetime.toLocalDate().isEqual(LocalDate.now());
    }

    /**
     * Checks if this task is due tomorrow.
     */
    public boolean isDueTomorrow() {
        if (dueDatetime == null) return false;
        return dueDatetime.toLocalDate().isEqual(LocalDate.now().plusDays(1));
    }

    /**
     * Human-readable representation of the preparation stage.
     */
    public String getDisplayStage() {
        if (prepStage == null) return "Pending";
        switch (prepStage.toUpperCase()) {
            case "PENDING":
                return "Pending Bench";
            case "IN_PREPARATION":
                return "In Preparation";
            case "READY_FOR_PICKUP":
                return "Ready for Pickup";
            case "COMPLETED":
                return "Completed";
            case "CANCELLED":
                return "Cancelled";
            default:
                return prepStage;
        }
    }

    private static final java.time.format.DateTimeFormatter DUE_FORMATTER =
            java.time.format.DateTimeFormatter.ofPattern("EEEE, MMM dd • hh:mm a");

    private static final java.time.format.DateTimeFormatter SHORT_DUE_FORMATTER =
            java.time.format.DateTimeFormatter.ofPattern("MMM dd, hh:mm a");

    public String getFormattedDueDatetime() {
        if (dueDatetime == null) return "N/A";
        return dueDatetime.format(DUE_FORMATTER);
    }

    public String getFormattedShortDueDatetime() {
        if (dueDatetime == null) return "N/A";
        return dueDatetime.format(SHORT_DUE_FORMATTER);
    }
}

