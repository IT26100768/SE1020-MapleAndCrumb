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

@WebServlet({"/cancelOrder", "/comp04-orders/cancelOrder"})
public class CancelOrderServlet extends HttpServlet {
    private OrderDAO orderDAO = new OrderDAOImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = session != null ? (User) session.getAttribute("loggedInUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/comp01-user/login.jsp?error=loginRequired");
            return;
        }

        String orderId = request.getParameter("orderId");
        if (orderId == null || orderId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/myOrders?error=invalid");
            return;
        }

        Order order = orderDAO.getOrderById(orderId.trim());
        if (order == null) {
            response.sendRedirect(request.getContextPath() + "/myOrders?error=notFound");
            return;
        }

        boolean isStaffOrAdmin = "ADMIN".equals(currentUser.getUserRole()) || "STAFF".equals(currentUser.getUserRole());

        // Ownership and authorization check
        if (!isStaffOrAdmin) {
            if (!order.getCustomerId().equals(currentUser.getUserID())) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
                return;
            }

            // Eligibility check: customers can only cancel Pending orders
            if (!"Pending".equalsIgnoreCase(order.getStatus())) {
                response.sendRedirect(request.getContextPath() + "/myOrders?error=cannotCancel");
                return;
            }
        }

        orderDAO.updateOrderStatus(orderId.trim(), "Cancelled");
        response.sendRedirect(request.getContextPath() + "/myOrders?msg=cancelled");
    }
}
