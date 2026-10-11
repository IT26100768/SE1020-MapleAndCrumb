package com.mapleandcrumb.model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public abstract class Order {
    private String orderId;
    private String customerId;
    private LocalDateTime orderDate;
    private String status;
    protected List<OrderItem> items;

    public Order(String orderId, String customerId) {
        this.orderId = orderId;
        this.customerId = customerId;
        this.orderDate = LocalDateTime.now();
        this.status = "Pending";
        this.items = new ArrayList<>();
    }

    public void addItem(OrderItem item) {
        this.items.add(item);
    }

    public String getOrderId() {
        return orderId;
    }

    public String getCustomerId() {
        return customerId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public List<OrderItem> getItems() {
        return items;
    }

    public abstract double calculateFinalTotal();
}
