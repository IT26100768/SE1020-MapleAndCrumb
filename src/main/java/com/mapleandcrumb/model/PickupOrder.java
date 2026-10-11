package com.mapleandcrumb.model;

public class PickupOrder extends Order {
    public PickupOrder(String orderId, String customerId) {
        super(orderId, customerId);
    }

    @Override
    public double calculateFinalTotal() {
        double total = 0;
        for (OrderItem item : getItems()) {
            total += item.getSubtotal();
        }
        return total;
    }
}
