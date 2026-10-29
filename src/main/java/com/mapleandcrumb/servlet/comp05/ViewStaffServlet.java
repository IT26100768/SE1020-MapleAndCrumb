
package com.mapleandcrumb.servlet.comp05;

import com.mapleandcrumb.dao.comp05.StaffDAO;
import com.mapleandcrumb.dao.impl.comp05.StaffDAOImpl;
import com.mapleandcrumb.model.comp05.Staff;
import com.mapleandcrumb.util.SecurityUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet({"/viewStaff", "/comp05-admin/viewStaff", "/comp05-admin/staff"})
public class ViewStaffServlet extends HttpServlet {
    private final StaffDAO staffDAO = new StaffDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!SecurityUtil.requireAdmin(request, response)) {
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
