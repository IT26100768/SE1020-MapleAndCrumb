package com.mapleandcrumb.dao.impl.comp01;

import com.mapleandcrumb.dao.comp01.UserDAO;
import com.mapleandcrumb.model.comp01.Customer;
import com.mapleandcrumb.model.comp01.User;
import com.mapleandcrumb.model.comp05.Admin;
import com.mapleandcrumb.model.comp05.Staff;
import com.mapleandcrumb.util.DBUtil;

import java.sql.*;
import java.util.List;

public class UserDAOImpl implements UserDAO {

    @Override
    public void registerUser(User user) {
        if (user == null) return;

        String address = (user instanceof Customer) ? ((Customer) user).getDeliveryAddress() : null;
        String staffId = (user instanceof Staff) ? ((Staff) user).getStaffId() : null;
        Double monthlySalary = (user instanceof Staff) ? ((Staff) user).getMonthlySalary() : null;
        String adminLevel = (user instanceof Admin) ? ((Admin) user).getAdminLevel() : null;

        String sql = "INSERT INTO users (user_code, username, password_hash, email, phone, role, address, staff_id, monthly_salary, admin_level) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?) "
                + "ON DUPLICATE KEY UPDATE "
                + "username = VALUES(username), password_hash = VALUES(password_hash), phone = VALUES(phone), "
                + "role = VALUES(role), address = VALUES(address), staff_id = VALUES(staff_id), "
                + "monthly_salary = VALUES(monthly_salary), admin_level = VALUES(admin_level)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getUserID());
            ps.setString(2, user.getUsername());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getPhone());
            ps.setString(6, user.getUserRole());
            ps.setString(7, address);
            ps.setString(8, staffId);
            if (monthlySalary != null) {
                ps.setDouble(9, monthlySalary);
            } else {
                ps.setNull(9, Types.DECIMAL);
            }
            ps.setString(10, adminLevel);
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next() && (user.getUserID() == null || user.getUserID().isEmpty())) {
                    user.setUserID(String.valueOf(rs.getInt(1)));
                }
            }
        } catch (SQLException e) {
            System.err.println("UserDAOImpl: Error registering user: " + e.getMessage());
        }
    }

    @Override
    public User searchUserByEmail(String email) {
        if (email == null || email.trim().isEmpty()) return null;
        return DBUtil.querySingle("SELECT * FROM users WHERE LOWER(email) = LOWER(?)", this::mapRowToUser, email.trim());
    }

    @Override
    public User searchUserByUsername(String username) {
        if (username == null || username.trim().isEmpty()) return null;
        return DBUtil.querySingle("SELECT * FROM users WHERE LOWER(username) = LOWER(?)", this::mapRowToUser, username.trim());
    }

    @Override
    public User searchUserByEmailOrUsername(String identifier) {
        if (identifier == null || identifier.trim().isEmpty()) return null;
        String val = identifier.trim();
        return DBUtil.querySingle("SELECT * FROM users WHERE LOWER(email) = LOWER(?) OR LOWER(username) = LOWER(?)",
                this::mapRowToUser, val, val);
    }

    @Override
    public User searchUserById(String userId) {
        if (userId == null || userId.trim().isEmpty()) return null;
        Integer numId = parseInteger(userId);
        String sql = (numId != null)
                ? "SELECT * FROM users WHERE user_id = ? OR user_code = ?"
                : "SELECT * FROM users WHERE user_code = ? OR staff_id = ? OR email = ? OR username = ?";
        return (numId != null)
                ? DBUtil.querySingle(sql, this::mapRowToUser, numId, userId.trim())
                : DBUtil.querySingle(sql, this::mapRowToUser, userId.trim(), userId.trim(), userId.trim(), userId.trim());
    }

    @Override
    public List<User> getAllUsers() {
        return DBUtil.queryList("SELECT * FROM users ORDER BY user_id ASC", this::mapRowToUser);
    }

    @Override
    public int getUserCount() {
        return DBUtil.queryCount("SELECT COUNT(*) FROM users");
    }

    @Override
    public void updateUser(User user) {
        if (user == null) return;
        String address = (user instanceof Customer) ? ((Customer) user).getDeliveryAddress() : null;
        String staffId = (user instanceof Staff) ? ((Staff) user).getStaffId() : null;
        Double monthlySalary = (user instanceof Staff) ? ((Staff) user).getMonthlySalary() : null;
        String adminLevel = (user instanceof Admin) ? ((Admin) user).getAdminLevel() : null;

        try (Connection conn = DBUtil.getConnection()) {
            Integer userId = DBUtil.findUserIdByCodeOrId(conn, user.getUserID());
            String sql = "UPDATE users SET username = ?, phone = ?, role = ?, address = ?, staff_id = ?, monthly_salary = ?, admin_level = ? "
                    + "WHERE user_id = ? OR user_code = ?";
            DBUtil.executeUpdate(sql, user.getUsername(), user.getPhone(), user.getUserRole(), address, staffId,
                    monthlySalary, adminLevel, userId != null ? userId : -1, user.getUserID());
        } catch (SQLException e) {
            System.err.println("UserDAOImpl: Error updating user: " + e.getMessage());
        }
    }

    @Override
    public boolean deleteUser(String userId) {
        if (userId == null || userId.trim().isEmpty()) return false;
        try (Connection conn = DBUtil.getConnection()) {
            Integer resolvedId = DBUtil.findUserIdByCodeOrId(conn, userId.trim());
            if (resolvedId != null) {
                return DBUtil.executeUpdate("DELETE FROM users WHERE user_id = ?", resolvedId) > 0;
            }
        } catch (SQLException ignored) {
        }

        Integer numId = parseInteger(userId);
        if (numId != null) {
            return DBUtil.executeUpdate("DELETE FROM users WHERE user_id = ? OR user_code = ?", numId, userId.trim()) > 0;
        }
        return DBUtil.executeUpdate("DELETE FROM users WHERE user_code = ? OR staff_id = ? OR email = ?",
                userId.trim(), userId.trim(), userId.trim()) > 0;
    }

    private Integer parseInteger(String val) {
        try {
            return Integer.parseInt(val.trim());
        } catch (Exception e) {
            return null;
        }
    }

    private User mapRowToUser(ResultSet rs) throws SQLException {
        String role = rs.getString("role");
        int userIdInt = rs.getInt("user_id");
        String userCode = rs.getString("user_code");
        String idToUse = (userCode != null && !userCode.trim().isEmpty()) ? userCode : String.valueOf(userIdInt);

        String username = rs.getString("username");
        String password = rs.getString("password_hash");
        String email = rs.getString("email");
        String phone = rs.getString("phone");

        if ("ADMIN".equalsIgnoreCase(role)) {
            String staffId = rs.getString("staff_id");
            String adminLevel = rs.getString("admin_level");
            return new Admin(idToUse, username, password, email, phone,
                    (staffId != null && !staffId.isEmpty()) ? staffId : "STF-" + userIdInt,
                    rs.getDouble("monthly_salary"),
                    (adminLevel != null && !adminLevel.isEmpty()) ? adminLevel : "Super");
        } else if ("STAFF".equalsIgnoreCase(role) || "BAKER".equalsIgnoreCase(role)) {
            String staffId = rs.getString("staff_id");
            return new Staff(idToUse, username, password, email, phone,
                    (staffId != null && !staffId.isEmpty()) ? staffId : "STF-" + userIdInt,
                    rs.getDouble("monthly_salary"));
        } else {
            String address = rs.getString("address");
            return new Customer(idToUse, username, password, email, phone, address != null ? address : "");
        }
    }
}
