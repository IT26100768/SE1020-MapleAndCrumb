

package com.mapleandcrumb.servlet.comp05;

import com.mapleandcrumb.dao.StaffDAO;
import com.mapleandcrumb.dao.UserDAO;
import com.mapleandcrumb.dao.impl.StaffDAOImpl;
import com.mapleandcrumb.dao.impl.UserDAOImpl;
import com.mapleandcrumb.model.Staff;
import com.mapleandcrumb.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet({"/removeStaff", "/comp05-admin/removeStaff"})
public class RemoveStaffServlet extends HttpServlet {
    private StaffDAO staffDAO = new StaffDAOImpl();
    private UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = session != null ? (User) session.getAttribute("loggedInUser") : null;

        // Security check: Only Admin can remove staff
        if (currentUser == null || !"ADMIN".equals(currentUser.getUserRole())) {
            response.sendRedirect(request.getContextPath() + "/comp01-user/login.jsp?error=unauthorized");
            return;
        }

        String staffId = request.getParameter("staffId");
        if (staffId == null || staffId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/viewStaff?error=invalid");
            return;
        }

        Staff staff = staffDAO.getStaffById(staffId.trim());
        if (staff != null) {
            // Guard against admin deleting their own active session user
            if (staff.getUserID().equals(currentUser.getUserID())) {
                response.sendRedirect(request.getContextPath() + "/viewStaff?error=cannotRemoveSelf");
                return;
            }
            staffDAO.removeStaff(staffId.trim());
            userDAO.deleteUser(staff.getUserID());
        }

        response.sendRedirect(request.getContextPath() + "/viewStaff?msg=removed");
    }
}


