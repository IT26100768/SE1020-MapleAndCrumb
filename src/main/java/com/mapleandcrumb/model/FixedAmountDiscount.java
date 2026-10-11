package com.mapleandcrumb.model;

import java.time.LocalDate;

public class FixedAmountDiscount extends Promotion {
    private double fixedAmount;

    public FixedAmountDiscount(String promoCode, String description, LocalDate expiryDate, double fixedAmount) {
        super(promoCode, description, expiryDate);
        this.fixedAmount = fixedAmount;
    }

    @Override
    public double applyDiscount(double originalPrice) {
        double finalPrice = originalPrice - fixedAmount;
        return Math.max(finalPrice, 0);
    }
}
