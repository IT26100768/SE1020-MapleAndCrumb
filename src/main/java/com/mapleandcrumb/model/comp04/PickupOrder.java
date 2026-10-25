package com.mapleandcrumb.model.comp04;

public class PickupOrder extends Order {
    public PickupOrder(String orderId, String customerId) {
        super(orderId, customerId);
    }

    @Override
    public double calculateFinalTotal() {
        return Math.max(0.0, getItemsSubtotal() - discount);
    }
}