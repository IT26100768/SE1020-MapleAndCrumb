package com.mapleandcrumb.model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

// ABSTRACTION: Base class for orders.
public abstract class Order {
    private String orderId;
    private String customerId;
    private LocalDateTime orderDate;
    private String status;
    protected List<OrderItem> items; // PROTECTED: Allows child classes to access directly if needed

    public Order(String orderId, String customerId) {
        this.orderId = orderId;
        this.customerId = customerId;
        this.orderDate = LocalDateTime.now();
        this.status = "Pending";
        this.items = new ArrayList<>();
    }

    public void addItem(OrderItem item) { this.items.add(item); }

    public String getOrderId() { return orderId; }
    public String getCustomerId() { return customerId; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public List<OrderItem> getItems() { return items; }

    // ABSTRACTION & POLYMORPHISM: Child classes must calculate totals differently.
    public abstract double calculateFinalTotal();
}
