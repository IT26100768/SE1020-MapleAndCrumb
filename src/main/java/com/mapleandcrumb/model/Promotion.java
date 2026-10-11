package com.mapleandcrumb.model;

import java.time.LocalDate;

public abstract class Promotion {

    private String promoCode;
    private String description;
    private LocalDate expiryDate;

    public Promotion(String promoCode, String description, LocalDate expiryDate) {
        this.promoCode = promoCode;
        this.description = description;
        this.expiryDate = expiryDate;
    }

    public String getPromoCode() {
        return promoCode;
    }

    public LocalDate getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(LocalDate expiryDate) {
        this.expiryDate = expiryDate;
    }

    public abstract double applyDiscount(double originalPrice);
}
