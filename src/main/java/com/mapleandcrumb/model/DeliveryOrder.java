package com.mapleandcrumb.model;

public class DeliveryOrder extends Order {
    private String deliveryAddress;
    private static final double DELIVERY_FEE = 5.00;

    public DeliveryOrder(String orderId, String customerId, String deliveryAddress) {
        super(orderId, customerId);
        this.deliveryAddress = deliveryAddress;
    }

    public String getDeliveryAddress() {
        return deliveryAddress;
    }

    @Override
    public double calculateFinalTotal() {
        double total = 0;
        for (OrderItem item : getItems()) {
            total += item.getSubtotal();
        }
        return total + DELIVERY_FEE;
    }
}
