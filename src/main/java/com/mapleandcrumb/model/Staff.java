package com.mapleandcrumb.model;

public class Staff extends User {

    private String staffId;
    private double monthlySalary;

    public Staff(String userId, String username, String password, String email, String phone, String staffId, double monthlySalary) {
        super(userId, username, password, email, phone);
        this.staffId = staffId;
        this.monthlySalary = monthlySalary;
    }

    public String getStaffId() {
        return staffId;
    }

    public double getMonthlySalary() {
        return monthlySalary;
    }

    @Override
    public boolean authentication(String inputPassword) {
        return this.getPassword().equals(inputPassword) && inputPassword.length() >= 8;
    }

    @Override
    public String getUserRole() {
        return "STAFF";
    }
}
