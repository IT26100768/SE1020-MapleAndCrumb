package com.mapleandcrumb.util;

import java.io.InputStream;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

/**
 * Utility class for managing MySQL database connections and common JDBC helpers.
 */
public class DBUtil {

    /**
     * Functional interface for mapping a ResultSet row to an object instance.
     */
    @FunctionalInterface
    public interface RowMapper<T> {
        T mapRow(ResultSet rs) throws SQLException;
    }

    private static final String DEFAULT_URL =
            "jdbc:mysql://localhost:3306/maple_and_crumb?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8";
    private static final String DEFAULT_USER = "root";
    private static final String DEFAULT_PASS = "";
    private static final String DEFAULT_DRIVER = "com.mysql.cj.jdbc.Driver";

    private static String url;
    private static String username;
    private static String password;
    private static String driver;

    static {
        loadConfig();
    }

    private static void loadConfig() {
        Properties props = new Properties();

        try (InputStream in = DBUtil.class.getResourceAsStream("/db.properties")) {
            if (in != null) {
                props.load(in);
            } else {
                System.err.println("DBUtil: db.properties not found on classpath. Using built-in defaults.");
            }
        } catch (Exception e) {
            System.err.println("DBUtil: Failed to read db.properties: " + e.getMessage());
        }

        driver = props.getProperty("db.driver", DEFAULT_DRIVER);
        url = props.getProperty("db.url", DEFAULT_URL);
        username = props.getProperty("db.username", DEFAULT_USER);
        password = props.getProperty("db.password", DEFAULT_PASS);

        try {
            Class.forName(driver);
        } catch (ClassNotFoundException e) {
            System.err.println("DBUtil: Failed to load JDBC driver [" + driver + "]: " + e.getMessage());
        }
    }

    /**
     * Obtains a new database connection from the driver manager.
     */
    public static Connection getConnection() throws SQLException {
        try {
            return DriverManager.getConnection(url, username, password);
        } catch (SQLException e) {
            System.err.println("DBUtil: Failed to connect to MySQL database at [" + url + "] as [" + username + "]. "
                    + "Please verify that MySQL service is running and maple_and_crumb schema is imported. Detail: " + e.getMessage());
            throw e;
        }
    }

    /**
     * Safely rolls back a transaction.
     */
    public static void rollbackQuietly(Connection conn) {
        if (conn != null) {
            try {
                conn.rollback();
            } catch (SQLException ignored) {
            }
        }
    }

    /**
     * Finds the user_id (INT) given either an integer ID or a user_code (e.g. "U_TEST_01").
     */
    public static Integer findUserIdByCodeOrId(Connection conn, String userIdentifier) {
        if (userIdentifier == null || userIdentifier.trim().isEmpty()) {
            return null;
        }
        String idStr = userIdentifier.trim();

        // 1. If numeric, check user_id first
        try {
            int numericId = Integer.parseInt(idStr);
            String sql = "SELECT user_id FROM users WHERE user_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, numericId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt("user_id");
                    }
                }
            }
        } catch (SQLException | NumberFormatException ignored) {
        }

        // 2. Search by user_code, email, or username
        String sql = "SELECT user_id FROM users WHERE user_code = ? OR email = ? OR username = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, idStr);
            ps.setString(2, idStr);
            ps.setString(3, idStr);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("user_id");
                }
            }
        } catch (SQLException e) {
            System.err.println("Error resolving user id for [" + idStr + "]: " + e.getMessage());
        }

        return null;
    }

    /**
     * Finds the product_id (INT) given either an integer ID or a product_code (e.g. "P_CHK_01").
     */
    public static Integer findProductIdByCodeOrId(Connection conn, String productIdentifier) {
        if (productIdentifier == null || productIdentifier.trim().isEmpty()) {
            return null;
        }
        String idStr = productIdentifier.trim();

        // 1. If numeric, check product_id first
        try {
            int numericId = Integer.parseInt(idStr);
            String sql = "SELECT product_id FROM products WHERE product_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, numericId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt("product_id");
                    }
                }
            }
        } catch (SQLException | NumberFormatException ignored) {
        }

        // 2. Search by product_code or name
        String sql = "SELECT product_id FROM products WHERE product_code = ? OR name = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, idStr);
            ps.setString(2, idStr);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("product_id");
                }
            }
        } catch (SQLException e) {
            System.err.println("Error resolving product id for [" + idStr + "]: " + e.getMessage());
        }

        return null;
    }

    /**
     * Binds parameters to a PreparedStatement with automatic null and temporal type handling.
     */
    public static void setParameters(PreparedStatement ps, Object... params) throws SQLException {
        if (params == null) return;
        for (int i = 0; i < params.length; i++) {
            Object p = params[i];
            if (p == null) {
                ps.setNull(i + 1, Types.NULL);
            } else if (p instanceof java.time.LocalDate) {
                ps.setDate(i + 1, java.sql.Date.valueOf((java.time.LocalDate) p));
            } else if (p instanceof java.time.LocalDateTime) {
                ps.setTimestamp(i + 1, java.sql.Timestamp.valueOf((java.time.LocalDateTime) p));
            } else {
                ps.setObject(i + 1, p);
            }
        }
    }

    /**
     * Executes a query and returns a list of mapped entities.
     */
    public static <T> List<T> queryList(String sql, RowMapper<T> mapper, Object... params) {
        List<T> list = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            setParameters(ps, params);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapper.mapRow(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("DBUtil.queryList error on [" + sql + "]: " + e.getMessage());
        }
        return list;
    }

    /**
     * Executes a query and returns a single mapped entity or null if none found.
     */
    public static <T> T querySingle(String sql, RowMapper<T> mapper, Object... params) {
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            setParameters(ps, params);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapper.mapRow(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("DBUtil.querySingle error on [" + sql + "]: " + e.getMessage());
        }
        return null;
    }

    /**
     * Executes an INSERT, UPDATE, or DELETE statement and returns the number of affected rows.
     */
    public static int executeUpdate(String sql, Object... params) {
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            setParameters(ps, params);
            return ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("DBUtil.executeUpdate error on [" + sql + "]: " + e.getMessage());
            return 0;
        }
    }

    /**
     * Executes a count query and returns the integer result. Safely manages connection and statement.
     */
    public static int queryCount(String sql, Object... params) {
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            setParameters(ps, params);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("DBUtil.queryCount error on [" + sql + "]: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Resolves the internal order_id (INT) given an integer ID or an order_code (e.g. "ORD-12345").
     */
    public static Integer findOrderIdByCodeOrId(Connection conn, String orderIdentifier) {
        if (orderIdentifier == null || orderIdentifier.trim().isEmpty()) {
            return null;
        }
        String idStr = orderIdentifier.trim();

        // 1. If numeric, check order_id first
        try {
            int numericId = Integer.parseInt(idStr);
            String sql = "SELECT order_id FROM orders WHERE order_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, numericId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt("order_id");
                    }
                }
            }
        } catch (SQLException | NumberFormatException ignored) {
        }

        // 2. Search by order_code
        String sql = "SELECT order_id FROM orders WHERE order_code = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, idStr);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("order_id");
                }
            }
        } catch (SQLException e) {
            System.err.println("DBUtil: Error resolving order id for [" + idStr + "]: " + e.getMessage());
        }

        return null;
    }

    /**
     * Resolves the internal custom cake request_id (INT) given an integer ID or a booking_code (e.g. "BKD65FD").
     */
    public static Integer findCakeRequestIdByCodeOrId(Connection conn, String bookingIdentifier) {
        if (bookingIdentifier == null || bookingIdentifier.trim().isEmpty()) {
            return null;
        }
        String idStr = bookingIdentifier.trim();

        // 1. If numeric, check request_id first
        try {
            int numericId = Integer.parseInt(idStr);
            String sql = "SELECT request_id FROM custom_cake_requests WHERE request_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, numericId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt("request_id");
                    }
                }
            }
        } catch (SQLException | NumberFormatException ignored) {
        }

        // 2. Search by booking_code
        String sql = "SELECT request_id FROM custom_cake_requests WHERE booking_code = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, idStr);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("request_id");
                }
            }
        } catch (SQLException e) {
            System.err.println("DBUtil: Error resolving cake request id for [" + idStr + "]: " + e.getMessage());
        }

        return null;
    }
}