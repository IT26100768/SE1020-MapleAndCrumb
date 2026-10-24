package com.mapleandcrumb.servlet.comp04;

import com.mapleandcrumb.dao.comp04.OrderDAO;
import com.mapleandcrumb.dao.impl.comp04.OrderDAOImpl;
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
import java.util.List;

@WebServlet({
        "/viewOrders",
        "/myOrders",
        "/my_orders",
        "/orderHistory",
        "/manageOrders",
        "/comp04-orders/orderHistory",
        "/comp04-orders/viewOrders"
})
public class ViewOrdersServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = SecurityUtil.getLoggedInUser(request);
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/comp01-user/login.jsp?error=unauthorized&redirect=myOrders");
            return;
        }

        String servletPath = request.getServletPath();
        String viewParam = ParamUtil.getTrimmed(request, "view");
        boolean isAdminOrStaff = SecurityUtil.isStaffOrAdmin(currentUser);
        boolean isExplicitMy = servletPath.contains("my") || "my".equalsIgnoreCase(viewParam);
        boolean isManagement = servletPath.contains("manage") || "all".equalsIgnoreCase(viewParam) || "manage".equalsIgnoreCase(viewParam)
                || (isAdminOrStaff && !isExplicitMy);

        if (isManagement) {
            if (!isAdminOrStaff) {
                response.sendRedirect(request.getContextPath() + "/comp01-user/login.jsp?error=unauthorized");
                return;
            }
            request.setAttribute("orders", orderDAO.getAllOrders());
            request.setAttribute("isManagerView", true);
            request.getRequestDispatcher("/comp04-orders/order_history.jsp").forward(request, response);
            return;
        }

        // Customer's personal order history
        List<Order> orders = orderDAO.getOrdersByCustomer(currentUser.getUserID());
        if (orders.isEmpty() && currentUser.getEmail() != null) {
            orders = orderDAO.getOrdersByCustomer(currentUser.getEmail());
        }
        if (orders.isEmpty() && currentUser.getUsername() != null) {
            orders = orderDAO.getOrdersByCustomer(currentUser.getUsername());
        }

        request.setAttribute("orders", orders);
        request.setAttribute("isManagerView", false);
        request.getRequestDispatcher("/comp04-orders/order_history.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}