package com.mapleandcrumb.servlet.comp05;

import com.mapleandcrumb.dao.comp05.StaffDAO;
import com.mapleandcrumb.dao.impl.comp05.StaffDAOImpl;
import com.mapleandcrumb.model.comp01.User;
import com.mapleandcrumb.model.comp05.Staff;
import com.mapleandcrumb.util.ParamUtil;
import com.mapleandcrumb.util.SecurityUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet({"/removeStaff", "/comp05-admin/removeStaff"})
public class RemoveStaffServlet extends HttpServlet {
    private final StaffDAO staffDAO = new StaffDAOImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!SecurityUtil.requireAdmin(request, response)) {
            return;
        }

        User currentUser = SecurityUtil.getLoggedInUser(request);
        String staffId = ParamUtil.getTrimmed(request, "staffId");
        if (staffId == null) {
            response.sendRedirect(request.getContextPath() + "/viewStaff?error=invalid");
            return;
        }

        Staff staff = staffDAO.getStaffById(staffId);
        if (staff != null) {
            // Guard against admin deleting their own active session user
            if (currentUser != null && staff.getUserID().equals(currentUser.getUserID())) {
                response.sendRedirect(request.getContextPath() + "/viewStaff?error=cannotRemoveSelf");
                return;
            }
            staffDAO.removeStaff(staffId);
        }

        response.sendRedirect(request.getContextPath() + "/viewStaff?msg=removed");
    }
}
