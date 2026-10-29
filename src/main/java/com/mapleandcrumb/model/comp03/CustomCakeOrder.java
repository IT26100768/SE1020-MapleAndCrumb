package com.mapleandcrumb.model.comp03;

import java.time.LocalDate;

public class CustomCakeOrder implements CakeBuilder {

    private String bookingId;
    private String customerId;
    private String flavor;
    private int sizeInches;
    private String customMessage;
    private LocalDate pickupDate;
    private String status;
    private double quotedPrice = -1.0;

    public CustomCakeOrder(String bookingId, String customerId, LocalDate pickupDate) {
        this.bookingId = bookingId;
        this.customerId = customerId;
        this.pickupDate = pickupDate;
        this.status = "Pending";
        this.customMessage = "";
    }

    @Override
    public void selectFlavor(String flavor) {
        this.flavor = flavor;
    }

    @Override
    public void selectSize(int inches) {
        this.sizeInches = inches;
    }

    @Override
    public void addCustomMessage(String message) {
        this.customMessage = message;
    }

    @Override
    public double calculateBasePrice() {
        switch (sizeInches) {
            case 6:  return 4500.00;
            case 8:  return 6500.00;
            case 10: return 8500.00;
            case 12: return 11000.00;
            default: return sizeInches > 0 ? sizeInches * 750.00 : 6500.00;
        }
    }

    public String getBookingId() {
        return bookingId;
    }

    public void setBookingId(String bookingId) {
        this.bookingId = bookingId;
    }

    public String getCustomerId() {
        return customerId;
    }

    public String getFlavor() {
        return flavor;
    }

    public int getSizeInches() {
        return sizeInches;
    }

    public String getSize() {
        return String.valueOf(sizeInches);
    }

    public String getCustomMessage() {
        return customMessage;
    }

    public LocalDate getPickupDate() {
        return pickupDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public double getQuotedPrice() {
        return quotedPrice > 0 ? quotedPrice : calculateBasePrice();
    }

    public void setQuotedPrice(double quotedPrice) {
        this.quotedPrice = quotedPrice;
    }
}