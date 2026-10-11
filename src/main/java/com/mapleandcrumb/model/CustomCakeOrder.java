package com.mapleandcrumb.model;

import java.time.LocalDate;

public class CustomCakeOrder implements CakeBuilder {

    private String bookingId;
    private String customerId;
    private String flavor;
    private int sizeInches;
    private String customMessage;
    private LocalDate pickupDate;
    private String status;

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
        return sizeInches * 15.00;
    }

    public String getBookingId() {
        return bookingId;
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
}
