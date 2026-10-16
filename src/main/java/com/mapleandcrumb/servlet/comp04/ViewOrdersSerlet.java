package com.mapleandcrumb.servlet.comp04;

import com.mapleandcrumb.dao.OrderDAO;
import com.mapleandcrumb.dao.impl.OrderDAOImpl;
import com.mapleandcrumb.model.Order;
import com.mapleandcrumb.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet({"/viewOrders", "/myOrders", "/comp04-orders/orders"})
public class ViewOrdersServlet extends HttpServlet {
    private OrderDAO orderDAO = new OrderDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = session != null ? (User) session.getAttribute("loggedInUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/comp01-user/login.jsp?error=loginRequired");
            return;
        }

        List<Order> orders;
        // Role check: Admin/Staff can see all orders, customers only see their own orders
        if ("ADMIN".equals(currentUser.getUserRole()) || "STAFF".equals(currentUser.getUserRole())) {
            orders = orderDAO.getAllOrders();
        } else {
            orders = orderDAO.getOrdersByCustomer(currentUser.getUserID());
        }

        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/comp04-orders/orders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

