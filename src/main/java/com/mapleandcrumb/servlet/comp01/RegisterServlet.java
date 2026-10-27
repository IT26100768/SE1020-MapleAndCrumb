package com.mapleandcrumb.servlet.comp01;

import com.mapleandcrumb.dao.comp01.UserDAO;
import com.mapleandcrumb.dao.impl.comp01.UserDAOImpl;
import com.mapleandcrumb.model.comp01.Customer;
import com.mapleandcrumb.model.comp01.User;
import com.mapleandcrumb.util.ParamUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.UUID;

@WebServlet({"/register", "/comp01-user/register"})
public class RegisterServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/comp01-user/register.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = ParamUtil.getTrimmed(request, "username");
        String password = ParamUtil.getTrimmed(request, "password");
        String email = ParamUtil.getTrimmed(request, "email");
        String phone = ParamUtil.getTrimmed(request, "phone", "");
        String address = ParamUtil.getTrimmed(request, "address", "");

        if (username == null || password == null || email == null) {
            response.sendRedirect(request.getContextPath() + "/comp01-user/register.jsp?error=invalid");
            return;
        }

        User existingUser = userDAO.searchUserByEmail(email);
        if (existingUser != null) {
            response.sendRedirect(request.getContextPath() + "/comp01-user/register.jsp?error=duplicate");
            return;
        }

        String userId = "U" + UUID.randomUUID().toString().substring(0, 5).toUpperCase();
        Customer newCustomer = new Customer(userId, username, password, email, phone, address);
        userDAO.registerUser(newCustomer);

        response.sendRedirect(request.getContextPath() + "/comp01-user/login.jsp?msg=success");
    }
}
