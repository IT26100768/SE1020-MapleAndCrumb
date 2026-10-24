package com.mapleandcrumb.model.comp04;

public class DeliveryOrder extends Order {
    private String deliveryAddress;
    public static final double DELIVERY_FEE = 500.00;

    public DeliveryOrder(String orderId, String customerId, String deliveryAddress) {
        super(orderId, customerId);
        this.deliveryAddress = deliveryAddress;
    }

    public String getDeliveryAddress() {
        return deliveryAddress;
    }

    @Override
    public double calculateFinalTotal() {
        return Math.max(0.0, getItemsSubtotal() - discount) + DELIVERY_FEE;
    }
}