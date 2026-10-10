package com.mapleandcrumb.model;

// Helper class for Cart Items
public class OrderItem {
    private String productId;
    private String productName;
    private int quantity;
    private double unitPrice;

    public OrderItem(String productId, String productName, int quantity, double unitPrice) {
        this.productId = productId;
        this.productName = productName;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
    }

    public double getSubtotal() { return quantity * unitPrice; }
    public String getProductId() { return productId; }
    public String getProductName() { return productName; }
    public int getQuantity() { return quantity; }
    public double getUnitPrice() { return unitPrice; }
}
