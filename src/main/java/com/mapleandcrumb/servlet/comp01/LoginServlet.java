package com.mapleandcrumb.servlet.comp01;

import com.mapleandcrumb.dao.UserDAO;
import com.mapleandcrumb.dao.impl.UserDAOImpl;
import com.mapleandcrumb.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAOImpl();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = userDAO.searchUserByEmail(email);

        // POLYMORPHISM: Using abstract authenticate method
        if (user != null && user.authentication(password)) {
            HttpSession session = request.getSession();
            session.setAttribute("loggedInUser", user);

            // Redirect based on user role
            if (user.getUserRole().equals("ADMIN")) {
                response.sendRedirect(request.getContextPath() + "/comp05-admin/dashboard.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/comp01-user/profile.jsp");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/comp01-user/login.jsp?error=invalid");
        }
    }
}
