package com.mapleandcrumb.model.comp06;

import java.time.LocalDate;

public abstract class Promotion {

    private String promoCode;
    private String description;
    private LocalDate expiryDate;

    public Promotion() {
    }

    public Promotion(String promoCode, String description, LocalDate expiryDate) {
        this.promoCode = promoCode;
        this.description = description;
        this.expiryDate = expiryDate;
    }

    public String getPromoCode() {
        return promoCode;
    }

    public void setPromoCode(String promoCode) {
        this.promoCode = promoCode;
    }

    public LocalDate getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(LocalDate expiryDate) {
        this.expiryDate = expiryDate;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public abstract double applyDiscount(double originalPrice);
}
