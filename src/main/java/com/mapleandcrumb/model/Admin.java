package com.mapleandcrumb.model;

public class Admin extends Staff {

    private String adminLevel;

    public Admin(String userId, String username, String password, String email, String phone, String staffId, double monthlySalary, String adminLevel) {
        super(userId, username, password, email, phone, staffId, monthlySalary);
        this.adminLevel = adminLevel;
    }

    public String getAdminLevel() {
        return adminLevel;
    }

    public void deleteSystemRecord(String recordId) {
        System.out.println("Admin " + getAdminLevel() + " deleted system record with ID: " + recordId);
    }

    @Override
    public String getUserRole() {
        return "ADMIN";
    }
}
