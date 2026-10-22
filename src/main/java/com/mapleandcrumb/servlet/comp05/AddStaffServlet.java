package com.mapleandcrumb.servlet.comp05;

import com.mapleandcrumb.dao.StaffDAO;
import com.mapleandcrumb.dao.UserDAO;
import com.mapleandcrumb.dao.impl.StaffDAOImpl;
import com.mapleandcrumb.dao.impl.UserDAOImpl;
import com.mapleandcrumb.model.Admin;
import com.mapleandcrumb.model.Staff;
import com.mapleandcrumb.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.UUID;

@WebServlet({"/addStaff", "/comp05-admin/addStaff"})
public class AddStaffServlet extends HttpServlet {
    private StaffDAO staffDAO = new StaffDAOImpl();
    private UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = session != null ? (User) session.getAttribute("loggedInUser") : null;

        // Security check: Only Admin can add staff
        if (currentUser == null || !"ADMIN".equals(currentUser.getUserRole())) {
            response.sendRedirect(request.getContextPath() + "/comp01-user/login.jsp?error=unauthorized");
            return;
        }

        request.getRequestDispatcher("/comp05-admin/add_staff.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = session != null ? (User) session.getAttribute("loggedInUser") : null;

        // Security check: Only Admin can add staff
        if (currentUser == null || !"ADMIN".equals(currentUser.getUserRole())) {
            response.sendRedirect(request.getContextPath() + "/comp01-user/login.jsp?error=unauthorized");
            return;
        }

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String salaryStr = request.getParameter("monthlySalary");
        String role = request.getParameter("role");
        String adminLevel = request.getParameter("adminLevel");

        if (username == null || username.trim().isEmpty() || password == null || password.trim().length() < 8
                || email == null || email.trim().isEmpty() || salaryStr == null || salaryStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/comp05-admin/add_staff.jsp?error=invalid");
            return;
        }

        double monthlySalary;
        try {
            monthlySalary = Double.parseDouble(salaryStr.trim());
            if (monthlySalary <= 0) {
                response.sendRedirect(request.getContextPath() + "/comp05-admin/add_staff.jsp?error=invalid");
                return;
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/comp05-admin/add_staff.jsp?error=invalid");
            return;
        }

        String userId = "U" + UUID.randomUUID().toString().substring(0, 5).toUpperCase();
        String staffId = "STF" + UUID.randomUUID().toString().substring(0, 4).toUpperCase();

        if ("ADMIN".equalsIgnoreCase(role)) {
            if (adminLevel == null || adminLevel.trim().isEmpty()) {
                adminLevel = "Super";
            }
            Admin admin = new Admin(userId, username.trim(), password.trim(), email.trim(),
                    phone != null ? phone.trim() : "", staffId, monthlySalary, adminLevel.trim());
            staffDAO.addStaff(admin);
            userDAO.registerUser(admin);
        } else {
            Staff staff = new Staff(userId, username.trim(), password.trim(), email.trim(),
                    phone != null ? phone.trim() : "", staffId, monthlySalary);
            staffDAO.addStaff(staff);
            userDAO.registerUser(staff);
        }

        response.sendRedirect(request.getContextPath() + "/viewStaff?msg=added");
    }
}

