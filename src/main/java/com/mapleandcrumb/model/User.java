package com.mapleandcrumb.model;

import java.time.LocalDateTime;

public abstract class User {
    private String userID;
    private String userName;
    private String password;
    private String email;
    private String phone;
    private LocalDateTime registrationDate;

    public User(String userID, String userName, String password, String email, String phone, LocalDateTime registrationDate) {
        this.userID = userID;
        this.userName = userName;
        this.password = password;
        this.email = email;
        this.phone = phone;
        this.registrationDate = registrationDate;
    }

    public String getUserID() {
        return userID;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public abstract boolean authentication(String inputPassword);

    public abstract String getUserRole();
}
