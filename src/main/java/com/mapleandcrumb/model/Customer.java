package com.mapleandcrumb.model;

import java.time.LocalDateTime;

public class Customer extends User {

    private String deliveryAddress;
    private int loyaltyPoints;

    public Customer(String userID, String userName, String password, String email, String phone, LocalDateTime registrationDate, String deliveryAddress) {
        super(userID, userName, password, email, phone, registrationDate);
        this.deliveryAddress = deliveryAddress;
        this.loyaltyPoints = 0;
    }

    public String getDeliveryAddress() {
        return deliveryAddress;
    }

    public void setDeliveryAddress(String deliveryAddress) {
        this.deliveryAddress = deliveryAddress;
    }

    public int getLoyaltyPoints() {
        return loyaltyPoints;
    }

    public void addLoyaltyPoints(int loyaltyPoints) {
        this.loyaltyPoints += loyaltyPoints;
    }

    @Override
    public boolean authentication(String inputPassword) {
        return this.getPassword().equals(inputPassword);
    }

    @Override
    public String getUserRole() {
        return "CUSTOMER";
    }
}
