package com.mapleandcrumb.model.comp05;

public class Admin extends Staff {

    private String adminLevel;

    public Admin(String userId, String username, String password, String email, String phone, String staffId, double monthlySalary, String adminLevel) {
        super(userId, username, password, email, phone, staffId, monthlySalary);
        this.adminLevel = adminLevel;
    }

    public String getAdminLevel() {
        return adminLevel;
    }

    @Override
    public String getUserRole() {
        return "ADMIN";
    }
}
