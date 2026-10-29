package com.mapleandcrumb.dao.comp05;

import com.mapleandcrumb.model.comp05.Staff;

import java.util.List;

public interface StaffDAO {

    void addStaff(Staff staff);

    Staff getStaffById(String staffId);

    List<Staff> getAllStaff();

    int getStaffCount();

    void updateStaff(Staff staff);

    void removeStaff(String staffId);
}

