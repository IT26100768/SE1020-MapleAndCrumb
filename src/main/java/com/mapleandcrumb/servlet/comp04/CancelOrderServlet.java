package com.mapleandcrumb.servlet.comp04;

import com.mapleandcrumb.dao.comp04.OrderDAO;
import com.mapleandcrumb.dao.comp05.KitchenTaskDAO;
import com.mapleandcrumb.dao.impl.comp04.OrderDAOImpl;
import com.mapleandcrumb.dao.impl.comp05.KitchenTaskDAOImpl;
import com.mapleandcrumb.model.comp01.User;
import com.mapleandcrumb.model.comp04.Order;
import com.mapleandcrumb.util.ParamUtil;
import com.mapleandcrumb.util.SecurityUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet({
        "/cancelOrder",
        "/comp04-orders/cancelOrder",
        "/comp04-orders/updateStatus"
})
public class CancelOrderServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAOImpl();
    private final KitchenTaskDAO kitchenTaskDAO = new KitchenTaskDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = SecurityUtil.getLoggedInUser(request);
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/comp01-user/login.jsp?error=unauthorized");
            return;
        }

        String orderId = ParamUtil.getTrimmed(request, "orderId");
        if (orderId == null) {
            orderId = ParamUtil.getTrimmed(request, "id");
        }
        if (orderId == null) {
            response.sendRedirect(request.getContextPath() + "/viewOrders?error=invalid");
            return;
        }

        String action = ParamUtil.getTrimmed(request, "action");
        String status = ParamUtil.getTrimmed(request, "status");
        boolean isAdminOrStaff = SecurityUtil.isStaffOrAdmin(currentUser);

        Order order = orderDAO.getOrderById(orderId);
        if (order == null) {
            response.sendRedirect(request.getContextPath()
                    + (isAdminOrStaff ? "/manageOrders?error=notfound" : "/myOrders?error=notfound"));
            return;
        }

        if (isAdminOrStaff) {
            if (status != null) {
                orderDAO.updateOrderStatus(orderId, status);
                kitchenTaskDAO.syncOrderStatus(orderId, status);
                response.sendRedirect(request.getContextPath() + "/manageOrders?msg=statusUpdated");
            } else if ("cancel".equalsIgnoreCase(action) || (request.getServletPath() != null && request.getServletPath().contains("cancelOrder"))) {
                orderDAO.cancelOrder(orderId);
                kitchenTaskDAO.syncOrderStatus(orderId, "Cancelled");
                response.sendRedirect(request.getContextPath() + "/manageOrders?msg=cancelled");
            } else {
                response.sendRedirect(request.getContextPath() + "/manageOrders?error=invalid");
            }
        } else {
            // Customer can only cancel their own pending order
            if (SecurityUtil.isOwner(currentUser, order.getCustomerId())) {
                orderDAO.cancelOrder(orderId);
                kitchenTaskDAO.syncOrderStatus(orderId, "Cancelled");
                response.sendRedirect(request.getContextPath() + "/myOrders?msg=cancelled");
            } else {
                response.sendRedirect(request.getContextPath() + "/myOrders?error=unauthorized");
            }
        }
    }
}