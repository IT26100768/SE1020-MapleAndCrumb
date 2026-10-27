package com.mapleandcrumb.model.comp04;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public abstract class Order {
    private String orderId;
    private String customerId;
    private LocalDateTime orderDate;
    private String status;
    protected List<OrderItem> items;
    protected double discount = 0.0;
    protected String promoCode;

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

    public void setOrderId(String orderId) {
        this.orderId = orderId;
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

    public LocalDateTime getOrderDate() {
        return orderDate;
    }

    public double getDiscount() {
        return discount;
    }

    public void setDiscount(double discount) {
        this.discount = Math.max(0.0, discount);
    }

    public String getPromoCode() {
        return promoCode;
    }

    public void setPromoCode(String promoCode) {
        this.promoCode = promoCode;
    }

    /**
     * Calculates the subtotal of all items in the order before discounts.
     */
    public double getItemsSubtotal() {
        double total = 0.0;
        if (items != null) {
            for (OrderItem item : items) {
                total += item.getSubtotal();
            }
        }
        return total;
    }

    public abstract double calculateFinalTotal();
}
