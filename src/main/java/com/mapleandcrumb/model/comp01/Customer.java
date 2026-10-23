package com.mapleandcrumb.model.comp01;

public class Customer extends User {

    private String deliveryAddress;

    public Customer(String userID, String userName, String password, String email, String phone, String deliveryAddress) {
        super(userID, userName, password, email, phone);
        this.deliveryAddress = deliveryAddress;
    }

    public String getDeliveryAddress() {
        return deliveryAddress;
    }

    public void setDeliveryAddress(String deliveryAddress) {
        this.deliveryAddress = deliveryAddress;
    }

    @Override
    public String getUserRole() {
        return "CUSTOMER";
    }
}
