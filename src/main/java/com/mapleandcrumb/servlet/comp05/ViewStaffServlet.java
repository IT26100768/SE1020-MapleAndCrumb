package com.mapleandcrumb.servlet.comp05;

import com.mapleandcrumb.dao.StaffDAO;
import com.mapleandcrumb.dao.impl.StaffDAOImpl;
import com.mapleandcrumb.model.Staff;
import com.mapleandcrumb.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet({"/viewStaff", "/comp05-admin/viewStaff", "/comp05-admin/staff"})
public class ViewStaffServlet extends HttpServlet {
    private StaffDAO staffDAO = new StaffDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = session != null ? (User) session.getAttribute("loggedInUser") : null;

        // Security check: Only Admin can view staff personnel
        if (currentUser == null || !"ADMIN".equals(currentUser.getUserRole())) {
            response.sendRedirect(request.getContextPath() + "/comp01-user/login.jsp?error=unauthorized");
            return;
        }

        List<Staff> staffList = staffDAO.getAllStaff();
        request.setAttribute("staffList", staffList);
        request.getRequestDispatcher("/comp05-admin/manage_staff.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}


