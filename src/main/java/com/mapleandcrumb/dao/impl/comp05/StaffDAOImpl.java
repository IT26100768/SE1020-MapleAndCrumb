package com.mapleandcrumb.dao.impl.comp05;

import com.mapleandcrumb.dao.comp05.StaffDAO;
import com.mapleandcrumb.model.comp05.Admin;
import com.mapleandcrumb.model.comp05.Staff;
import com.mapleandcrumb.util.DBUtil;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class StaffDAOImpl implements StaffDAO {

    @Override
    public void addStaff(Staff staff) {
        if (staff == null) return;
        String adminLevel = (staff instanceof Admin) ? ((Admin) staff).getAdminLevel() : null;
        String sql = "INSERT INTO users (user_code, username, password_hash, email, phone, role, staff_id, monthly_salary, admin_level) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?) "
                + "ON DUPLICATE KEY UPDATE "
                + "username = VALUES(username), password_hash = VALUES(password_hash), phone = VALUES(phone), "
                + "role = VALUES(role), staff_id = VALUES(staff_id), monthly_salary = VALUES(monthly_salary), admin_level = VALUES(admin_level)";
        DBUtil.executeUpdate(sql, staff.getUserID(), staff.getUsername(), staff.getPassword(), staff.getEmail(),
                staff.getPhone(), staff.getUserRole(), staff.getStaffId(), staff.getMonthlySalary(), adminLevel);
    }

    @Override
    public Staff getStaffById(String staffId) {
        if (staffId == null || staffId.trim().isEmpty()) return null;
        String sql = "SELECT * FROM users WHERE staff_id = ? AND role IN ('STAFF', 'ADMIN', 'BAKER')";
        return DBUtil.querySingle(sql, this::mapRowToStaff, staffId.trim());
    }

    @Override
    public List<Staff> getAllStaff() {
        String sql = "SELECT * FROM users WHERE role IN ('STAFF', 'ADMIN', 'BAKER') ORDER BY user_id ASC";
        return DBUtil.queryList(sql, this::mapRowToStaff);
    }

    @Override
    public int getStaffCount() {
        return DBUtil.queryCount("SELECT COUNT(*) FROM users WHERE role IN ('STAFF', 'ADMIN', 'BAKER')");
    }

    @Override
    public void updateStaff(Staff staff) {
        if (staff == null) return;
        String adminLevel = (staff instanceof Admin) ? ((Admin) staff).getAdminLevel() : null;
        String sql = "UPDATE users SET username = ?, phone = ?, monthly_salary = ?, admin_level = ? WHERE staff_id = ?";
        DBUtil.executeUpdate(sql, staff.getUsername(), staff.getPhone(), staff.getMonthlySalary(), adminLevel, staff.getStaffId());
    }

    @Override
    public void removeStaff(String staffId) {
        if (staffId == null || staffId.trim().isEmpty()) return;
        DBUtil.executeUpdate("DELETE FROM users WHERE staff_id = ?", staffId.trim());
    }

    private Staff mapRowToStaff(ResultSet rs) throws SQLException {
        String role = rs.getString("role");
        int userIdInt = rs.getInt("user_id");
        String userCode = rs.getString("user_code");
        String idToUse = (userCode != null && !userCode.trim().isEmpty()) ? userCode : String.valueOf(userIdInt);

        String username = rs.getString("username");
        String password = rs.getString("password_hash");
        String email = rs.getString("email");
        String phone = rs.getString("phone");
        String staffId = rs.getString("staff_id");
        if (staffId == null || staffId.isEmpty()) {
            staffId = "STF-" + userIdInt;
        }
        double monthlySalary = rs.getDouble("monthly_salary");

        if ("ADMIN".equalsIgnoreCase(role)) {
            String adminLevel = rs.getString("admin_level");
            return new Admin(idToUse, username, password, email, phone, staffId, monthlySalary,
                    (adminLevel != null && !adminLevel.isEmpty()) ? adminLevel : "Super");
        }
        return new Staff(idToUse, username, password, email, phone, staffId, monthlySalary);
    }
}
