package com.mapleandcrumb.servlet.comp04;

import com.mapleandcrumb.dao.OrderDAO;
import com.mapleandcrumb.dao.ProductDAO;
import com.mapleandcrumb.dao.impl.OrderDAOImpl;
import com.mapleandcrumb.dao.impl.ProductDAOImpl;
import com.mapleandcrumb.model.Customer;
import com.mapleandcrumb.model.DeliveryOrder;
import com.mapleandcrumb.model.Order;
import com.mapleandcrumb.model.OrderItem;
import com.mapleandcrumb.model.PickupOrder;
import com.mapleandcrumb.model.Product;
import com.mapleandcrumb.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.UUID;

@WebServlet({"/checkout", "/comp04-orders/checkout"})
public class CheckoutServlet extends HttpServlet {
    private OrderDAO orderDAO = new OrderDAOImpl();
    private ProductDAO productDAO = new ProductDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = session != null ? (User) session.getAttribute("loggedInUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/comp01-user/login.jsp?error=loginRequired");
            return;
        }

        String productId = request.getParameter("productId");
        if (productId != null && !productId.trim().isEmpty()) {
            Product selectedProduct = productDAO.getProductById(productId.trim());
            request.setAttribute("selectedProduct", selectedProduct);
        }
        request.setAttribute("products", productDAO.getAllProducts());

        request.getRequestDispatcher("/comp04-orders/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = session != null ? (User) session.getAttribute("loggedInUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/comp01-user/login.jsp?error=loginRequired");
            return;
        }

        String orderType = request.getParameter("orderType");
        String deliveryAddress = request.getParameter("deliveryAddress");
        String productId = request.getParameter("productId");
        String quantityStr = request.getParameter("quantity");

        if (productId == null || productId.trim().isEmpty() || quantityStr == null || quantityStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/comp04-orders/checkout.jsp?error=invalid");
            return;
        }

        int quantity;
        try {
            quantity = Integer.parseInt(quantityStr.trim());
            if (quantity <= 0) {
                response.sendRedirect(request.getContextPath() + "/comp04-orders/checkout.jsp?error=invalidQuantity");
                return;
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/comp04-orders/checkout.jsp?error=invalidQuantity");
            return;
        }

        // Security check: Validate product and price on server side
        Product product = productDAO.getProductById(productId.trim());
        if (product == null) {
            response.sendRedirect(request.getContextPath() + "/comp04-orders/checkout.jsp?error=productNotFound");
            return;
        }

        if (product.getStockQuantity() < quantity) {
            response.sendRedirect(request.getContextPath() + "/comp04-orders/checkout.jsp?productId=" + productId + "&error=insufficientStock");
            return;
        }

        String orderId = "ORD" + UUID.randomUUID().toString().substring(0, 5).toUpperCase();
        // Server-enforced customer ownership
        String customerId = currentUser.getUserID();

        Order order;
        if ("Delivery".equalsIgnoreCase(orderType)) {
            if ((deliveryAddress == null || deliveryAddress.trim().isEmpty()) && currentUser instanceof Customer) {
                deliveryAddress = ((Customer) currentUser).getDeliveryAddress();
            }
            if (deliveryAddress == null || deliveryAddress.trim().isEmpty()) {
                deliveryAddress = "Customer Address on File";
            }
            order = new DeliveryOrder(orderId, customerId, deliveryAddress.trim());
        } else {
            order = new PickupOrder(orderId, customerId);
        }

        // Add item using server-verified price
        order.addItem(new OrderItem(product.getProductId(), product.getName(), quantity, product.getPrice()));
        orderDAO.createOrder(order);

        // Update product inventory
        product.setStockQuantity(product.getStockQuantity() - quantity);
        productDAO.updateProduct(product);

        response.sendRedirect(request.getContextPath() + "/myOrders?msg=orderPlaced");
    }
}
