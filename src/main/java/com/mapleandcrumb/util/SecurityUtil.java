package com.mapleandcrumb.util;

import com.mapleandcrumb.dao.comp01.UserDAO;
import com.mapleandcrumb.model.comp01.Customer;
import com.mapleandcrumb.model.comp01.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.UUID;

public final class SecurityUtil {

    private SecurityUtil() {
    }

    public static User getLoggedInUser(HttpServletRequest request) {
        if (request == null) return null;
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        Object userObj = session.getAttribute("loggedInUser");
        return (userObj instanceof User) ? (User) userObj : null;
    }

    public static boolean isAuthenticated(HttpServletRequest request) {
        return getLoggedInUser(request) != null;
    }

    public static boolean isStaffOrAdmin(User user) {
        if (user == null || user.getUserRole() == null) return false;
        String role = user.getUserRole();
        return "ADMIN".equals(role) || "STAFF".equals(role) || "BAKER".equals(role);
    }

    public static boolean isAdmin(User user) {
        return user != null && "ADMIN".equals(user.getUserRole());
    }

    public static boolean isCustomer(User user) {
        return user != null && "CUSTOMER".equals(user.getUserRole());
    }

    public static boolean isOwner(User user, String ownerId) {
        if (user == null || ownerId == null || ownerId.trim().isEmpty()) {
            return false;
        }
        String cleanOwnerId = ownerId.trim();
        return cleanOwnerId.equalsIgnoreCase(user.getUserID())
                || (user.getEmail() != null && cleanOwnerId.equalsIgnoreCase(user.getEmail().trim()))
                || (user.getUsername() != null && cleanOwnerId.equalsIgnoreCase(user.getUsername().trim()));
    }

    public static String resolveOrRegisterCustomer(HttpServletRequest request, UserDAO userDAO, String defaultAddress) {
        if (request == null) return null;
        HttpSession session = request.getSession(true);
        User currentUser = getLoggedInUser(request);

        if (currentUser != null) {
            String customerId = currentUser.getUserID();
            return (customerId != null && !customerId.trim().isEmpty()) ? customerId : currentUser.getEmail();
        }

        String guestEmail = ParamUtil.getTrimmed(request, "customerEmail");
        if (guestEmail == null) {
            return null;
        }

        User existing = userDAO != null ? userDAO.searchUserByEmail(guestEmail) : null;
        if (existing != null) {
            session.setAttribute("loggedInUser", existing);
            return (existing.getUserID() != null && !existing.getUserID().trim().isEmpty())
                    ? existing.getUserID()
                    : existing.getEmail();
        }

        String guestName = ParamUtil.getTrimmed(request, "customerName", "Guest Customer");
        String guestPhone = ParamUtil.getTrimmed(request, "customerPhone", "N/A");
        String newUserId = "CUST-" + UUID.randomUUID().toString().substring(0, 6).toUpperCase();
        Customer newCust = new Customer(newUserId, guestName, "guestPassword", guestEmail, guestPhone,
                defaultAddress != null ? defaultAddress : "Bakery Pickup Counter");
        if (userDAO != null) {
            userDAO.registerUser(newCust);
        }
        session.setAttribute("loggedInUser", newCust);
        return newUserId;
    }

    public static boolean requireStaffOrAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = getLoggedInUser(request);
        if (!isStaffOrAdmin(user)) {
            response.sendRedirect(request.getContextPath() + "/comp01-user/login.jsp?error=unauthorized");
            return false;
        }
        return true;
    }

    public static boolean requireAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = getLoggedInUser(request);
        if (!isAdmin(user)) {
            response.sendRedirect(request.getContextPath() + "/comp01-user/login.jsp?error=unauthorized");
            return false;
        }
        return true;
    }

    public static boolean requireAuthenticated(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = getLoggedInUser(request);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/comp01-user/login.jsp?error=unauthorized");
            return false;
        }
        return true;
    }
}

