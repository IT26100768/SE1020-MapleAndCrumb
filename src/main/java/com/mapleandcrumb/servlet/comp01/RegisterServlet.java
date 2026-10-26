package com.mapleandcrumb.servlet.comp01;

import com.mapleandcrumb.dao.UserDAO;
import com.mapleandcrumb.dao.impl.UserDAOImpl;
import com.mapleandcrumb.model.Customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.UUID;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAOImpl();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 1. Extract form data
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        // 2. Create Customer object
        String userId = "U" + UUID.randomUUID().toString().substring(0, 5).toUpperCase();
        Customer newCustomer = new Customer(userId, username, password, email, phone, address);

        // 3. Save to file via DAO
        userDAO.registerUser(newCustomer);

        // 4. Redirect to login with success message
        response.sendRedirect(request.getContextPath() + "/comp01-user/login.jsp?msg=success");
    }
}
