package com.mapleandcrumb.model;

import java.time.LocalDate;

public class PercentageDiscount extends Promotion {

    private double percentage;

    public PercentageDiscount(String promoCode, String description, LocalDate expiryDate, double percentage) {
        super(promoCode, description, expiryDate);
        this.percentage = percentage;
    }

    @Override
    public double applyDiscount(double originalPrice) {
        return originalPrice - (originalPrice * (percentage / 100));
    }
}
