package com.mapleandcrumb.dao;

import com.mapleandcrumb.model.Staff;

import java.util.List;

public interface StaffDAO {

    void addStaff(Staff staff);

    Staff getStaffById(String staffId);

    List<Staff> getAllStaff();

    void updateStaff(Staff staff);

    void removeStaff(String staffId);
}
