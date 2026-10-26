package com.mapleandcrumb.servlet.comp01;

import com.mapleandcrumb.dao.UserDAO;
import com.mapleandcrumb.dao.impl.UserDAOImpl;
import com.mapleandcrumb.model.Customer;
import com.mapleandcrumb.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/updateProfile")
public class UpdateProfileServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAOImpl();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("loggedInUser");

        if (currentUser instanceof Customer) {
            Customer c = (Customer) currentUser;
            c.setPhone(request.getParameter("phone"));
            c.setDeliveryAddress(request.getParameter("address"));

            userDAO.updateUser(c);
            response.sendRedirect(request.getContextPath() + "/comp01-user/profile.jsp?msg=updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/comp01-user/login.jsp");
        }
    }
}
