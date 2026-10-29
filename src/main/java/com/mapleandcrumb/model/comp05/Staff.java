package com.mapleandcrumb.model.comp05;

import com.mapleandcrumb.model.comp01.User;

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
    public String getUserRole() {
        return "STAFF";
    }
}

