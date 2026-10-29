package com.mapleandcrumb.model.comp06;

import java.time.LocalDate;

public class FixedAmountDiscount extends Promotion {
    private double fixedAmount;

    public FixedAmountDiscount() {
        super();
    }

    public FixedAmountDiscount(String promoCode, String description, LocalDate expiryDate, double fixedAmount) {
        super(promoCode, description, expiryDate);
        this.fixedAmount = fixedAmount;
    }

    public double getFixedAmount() {
        return fixedAmount;
    }

    public void setFixedAmount(double fixedAmount) {
        this.fixedAmount = fixedAmount;
    }

    @Override
    public double applyDiscount(double originalPrice) {
        double finalPrice = originalPrice - fixedAmount;
        return Math.max(finalPrice, 0);
    }
}
