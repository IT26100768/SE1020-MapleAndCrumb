package com.mapleandcrumb.model;

import java.time.LocalDateTime;

public abstract class User {
    private String userID;
    private String username; // lowercase 'n' — matches JSP EL ${user.username} → getUsername()
    private String password;
    private String email;
    private String phone;
    private LocalDateTime registrationDate;

    public User(String userID, String username, String password, String email, String phone) {
        this.userID = userID;
        this.username = username;
        this.password = password;
        this.email = email;
        this.phone = phone;
        this.registrationDate = LocalDateTime.now();
    }

    public String getUserID() {
        return userID;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    // getUsername() → JSP EL resolves ${user.username} correctly
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
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
