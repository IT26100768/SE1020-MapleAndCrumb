package com.mapleandcrumb.servlet.comp01;

import com.mapleandcrumb.dao.comp01.UserDAO;
import com.mapleandcrumb.dao.impl.comp01.UserDAOImpl;
import com.mapleandcrumb.model.comp01.User;
import com.mapleandcrumb.util.ParamUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet({"/login", "/comp01-user/login"})
public class LoginServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/comp01-user/login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String identifier = ParamUtil.getTrimmed(request, "email");
        if (identifier == null) {
            identifier = ParamUtil.getTrimmed(request, "username");
        }
        String password = ParamUtil.getTrimmed(request, "password");

        if (identifier == null || password == null) {
            response.sendRedirect(request.getContextPath() + "/comp01-user/login.jsp?error=invalid");
            return;
        }

        User user = userDAO.searchUserByEmailOrUsername(identifier);

        if (user != null && user.getPassword() != null && (user.getPassword().equals(password) || user.getPassword().equals(password.trim()))) {
            HttpSession session = request.getSession();
            session.setAttribute("loggedInUser", user);

            if ("ADMIN".equals(user.getUserRole()) || "STAFF".equals(user.getUserRole())) {
                response.sendRedirect(request.getContextPath() + "/comp05-admin/dashboard.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/comp01-user/profile.jsp");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/comp01-user/login.jsp?error=invalid");
        }
    }
}
