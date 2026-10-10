package com.mapleandcrumb.model;

// INHERITANCE
public class PickupOrder extends Order {
    public PickupOrder(String orderId, String customerId) {
        super(orderId, customerId);
    }

    // POLYMORPHISM: Pickup orders have no extra fees.
    @Override
    public double calculateFinalTotal() {
        double total = 0;
        for (OrderItem item : getItems()) {
            total += item.getSubtotal();
        }
        return total;
    }
}
