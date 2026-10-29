package com.mapleandcrumb.servlet.comp05;

import com.mapleandcrumb.dao.comp05.StaffDAO;
import com.mapleandcrumb.dao.impl.comp05.StaffDAOImpl;
import com.mapleandcrumb.model.comp05.Admin;
import com.mapleandcrumb.model.comp05.Staff;
import com.mapleandcrumb.util.ParamUtil;
import com.mapleandcrumb.util.SecurityUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.UUID;

@WebServlet({"/addStaff", "/comp05-admin/addStaff"})
public class AddStaffServlet extends HttpServlet {
    private final StaffDAO staffDAO = new StaffDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!SecurityUtil.requireAdmin(request, response)) {
            return;
        }
        request.getRequestDispatcher("/comp05-admin/add_staff.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!SecurityUtil.requireAdmin(request, response)) {
            return;
        }

        String username = ParamUtil.getTrimmed(request, "username");
        String password = ParamUtil.getTrimmed(request, "password");
        String email = ParamUtil.getTrimmed(request, "email");
        String phone = ParamUtil.getTrimmed(request, "phone", "");
        Double monthlySalary = ParamUtil.getDouble(request, "monthlySalary");
        String role = ParamUtil.getTrimmed(request, "role", "STAFF");
        String adminLevel = ParamUtil.getTrimmed(request, "adminLevel", "Super");

        if (username == null || password == null || password.length() < 8
                || email == null || monthlySalary == null || monthlySalary <= 0) {
            response.sendRedirect(request.getContextPath() + "/comp05-admin/add_staff.jsp?error=invalid");
            return;
        }

        String formStaffId = ParamUtil.getTrimmed(request, "staffId");
        String staffId = (formStaffId != null)
                ? formStaffId
                : "STF" + UUID.randomUUID().toString().substring(0, 4).toUpperCase();
        String userId = "U" + UUID.randomUUID().toString().substring(0, 5).toUpperCase();

        Staff staff = "ADMIN".equalsIgnoreCase(role)
                ? new Admin(userId, username, password, email, phone, staffId, monthlySalary, adminLevel)
                : new Staff(userId, username, password, email, phone, staffId, monthlySalary);

        staffDAO.addStaff(staff);
        response.sendRedirect(request.getContextPath() + "/viewStaff?msg=added");
    }
}

