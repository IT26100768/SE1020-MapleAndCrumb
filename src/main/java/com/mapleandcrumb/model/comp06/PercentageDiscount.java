package com.mapleandcrumb.model.comp06;

import java.time.LocalDate;

public class PercentageDiscount extends Promotion {

    private double percentage;

    public PercentageDiscount() {
        super();
    }

    public PercentageDiscount(String promoCode, String description, LocalDate expiryDate, double percentage) {
        super(promoCode, description, expiryDate);
        this.percentage = percentage;
    }

    public double getPercentage() {
        return percentage;
    }

    public void setPercentage(double percentage) {
        this.percentage = percentage;
    }

    @Override
    public double applyDiscount(double originalPrice) {
        return originalPrice - (originalPrice * (percentage / 100));
    }
}
