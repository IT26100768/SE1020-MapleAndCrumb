package com.mapleandcrumb.servlet.comp01;

import com.mapleandcrumb.dao.comp01.UserDAO;
import com.mapleandcrumb.dao.impl.comp01.UserDAOImpl;
import com.mapleandcrumb.model.comp01.Customer;
import com.mapleandcrumb.model.comp01.User;
import com.mapleandcrumb.util.ParamUtil;
import com.mapleandcrumb.util.SecurityUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet({"/updateProfile", "/comp01-user/updateProfile"})
public class UpdateProfileServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String target = SecurityUtil.isAuthenticated(request) ? "/comp01-user/profile.jsp" : "/comp01-user/login.jsp";
        response.sendRedirect(request.getContextPath() + target);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = SecurityUtil.getLoggedInUser(request);
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/comp01-user/login.jsp?error=unauthorized");
            return;
        }

        String phone = ParamUtil.getTrimmed(request, "phone");
        if (phone != null) {
            currentUser.setPhone(phone);
        }
        if (currentUser instanceof Customer customer) {
            String address = ParamUtil.getTrimmed(request, "address");
            if (address != null) {
                customer.setDeliveryAddress(address);
            }
        }

        userDAO.updateUser(currentUser);
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.setAttribute("loggedInUser", currentUser);
        }
        response.sendRedirect(request.getContextPath() + "/comp01-user/profile.jsp?msg=updated");
    }
}
