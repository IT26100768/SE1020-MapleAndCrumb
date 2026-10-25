package com.mapleandcrumb.servlet.comp04;

import com.mapleandcrumb.dao.comp01.UserDAO;
import com.mapleandcrumb.dao.comp02.ProductDAO;
import com.mapleandcrumb.dao.comp04.OrderDAO;
import com.mapleandcrumb.dao.comp05.KitchenTaskDAO;
import com.mapleandcrumb.dao.comp06.PromotionDAO;
import com.mapleandcrumb.dao.impl.comp01.UserDAOImpl;
import com.mapleandcrumb.dao.impl.comp02.ProductDAOImpl;
import com.mapleandcrumb.dao.impl.comp04.OrderDAOImpl;
import com.mapleandcrumb.dao.impl.comp05.KitchenTaskDAOImpl;
import com.mapleandcrumb.dao.impl.comp06.PromotionDAOImpl;
import com.mapleandcrumb.model.comp02.Product;
import com.mapleandcrumb.model.comp04.DeliveryOrder;
import com.mapleandcrumb.model.comp04.Order;
import com.mapleandcrumb.model.comp04.OrderItem;
import com.mapleandcrumb.model.comp04.PickupOrder;
import com.mapleandcrumb.model.comp06.Promotion;
import com.mapleandcrumb.util.ParamUtil;
import com.mapleandcrumb.util.SecurityUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.UUID;

@WebServlet({
        "/checkout",
        "/comp04-orders/checkout",
        "/cart/checkout",
        "/orderSuccess",
        "/comp04-orders/orderSuccess"
})
public class CheckoutServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAOImpl();
    private final ProductDAO productDAO = new ProductDAOImpl();
    private final UserDAO userDAO = new UserDAOImpl();
    private final PromotionDAO promotionDAO = new PromotionDAOImpl();
    private final KitchenTaskDAO kitchenTaskDAO = new KitchenTaskDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();

        // 1. Handle Order Success Confirmation Display
        if (servletPath.contains("orderSuccess") || (request.getParameter("orderId") != null && "success".equals(request.getParameter("view")))) {
            String orderId = ParamUtil.getTrimmed(request, "orderId");
            if (orderId != null) {
                Order order = orderDAO.getOrderById(orderId);
                if (order != null) {
                    request.setAttribute("order", order);
                    request.setAttribute("paymentMethod", orderDAO.getPaymentMethod(orderId));
                    request.getRequestDispatcher("/comp04-orders/order_success.jsp").forward(request, response);
                    return;
                }
            }
            response.sendRedirect(request.getContextPath() + "/viewOrders");
            return;
        }

        // 2. Handle Cart Operations (Add / Remove / Update / Clear / Apply Promo)
        HttpSession session = request.getSession(true);
        @SuppressWarnings("unchecked")
        List<OrderItem> cart = (List<OrderItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
        }

        String action = ParamUtil.getTrimmed(request, "action");
        String productId = ParamUtil.getTrimmed(request, "productId");

        // Handle Promo Code Application / Removal
        if ("applyPromo".equalsIgnoreCase(action) || request.getParameter("promoCode") != null) {
            String promoCode = ParamUtil.getTrimmed(request, "promoCode");
            if (promoCode != null) {
                Promotion promo = promotionDAO.getPromotionByCode(promoCode);
                if (promo != null && (promo.getExpiryDate() == null || !promo.getExpiryDate().isBefore(LocalDate.now()))) {
                    double itemsSubtotal = calculateCartSubtotal(cart);
                    double discountAmount = Math.max(0.0, itemsSubtotal - promo.applyDiscount(itemsSubtotal));
                    session.setAttribute("appliedPromoCode", promo.getPromoCode());
                    session.setAttribute("appliedDiscount", discountAmount);
                    response.sendRedirect(request.getContextPath() + "/checkout?msg=promoApplied");
                    return;
                } else {
                    session.removeAttribute("appliedPromoCode");
                    session.removeAttribute("appliedDiscount");
                    String err = (promo != null) ? "promoExpired" : "invalidPromo";
                    response.sendRedirect(request.getContextPath() + "/checkout?error=" + err);
                    return;
                }
            }
        } else if ("removePromo".equalsIgnoreCase(action)) {
            session.removeAttribute("appliedPromoCode");
            session.removeAttribute("appliedDiscount");
            response.sendRedirect(request.getContextPath() + "/checkout?msg=promoRemoved");
            return;
        }

        if ("add".equalsIgnoreCase(action) || (action == null && productId != null)) {
            if (productId != null) {
                Product product = productDAO.getProductById(productId);
                if (product != null) {
                    int qty = Math.max(1, ParamUtil.getInt(request, "qty", 1));
                    boolean found = false;
                    for (int i = 0; i < cart.size(); i++) {
                        OrderItem item = cart.get(i);
                        if (item.getProductId() != null && item.getProductId().equalsIgnoreCase(product.getProductId())) {
                            cart.set(i, new OrderItem(product.getProductId(), product.getName(), item.getQuantity() + qty, product.getPrice()));
                            found = true;
                            break;
                        }
                    }
                    if (!found) {
                        cart.add(new OrderItem(product.getProductId(), product.getName(), qty, product.getPrice()));
                    }
                }
            }
            if ("add".equalsIgnoreCase(action)) {
                response.sendRedirect(request.getContextPath() + "/checkout");
                return;
            }
        } else if ("remove".equalsIgnoreCase(action) && productId != null) {
            Iterator<OrderItem> it = cart.iterator();
            while (it.hasNext()) {
                OrderItem item = it.next();
                if (item.getProductId() != null && item.getProductId().equalsIgnoreCase(productId)) {
                    it.remove();
                    break;
                }
            }
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        } else if ("update".equalsIgnoreCase(action) && productId != null) {
            int newQty = ParamUtil.getInt(request, "qty", 0);
            for (int i = 0; i < cart.size(); i++) {
                OrderItem item = cart.get(i);
                if (item.getProductId() != null && item.getProductId().equalsIgnoreCase(productId)) {
                    if (newQty <= 0) {
                        cart.remove(i);
                    } else {
                        cart.set(i, new OrderItem(item.getProductId(), item.getProductName(), newQty, item.getUnitPrice()));
                    }
                    break;
                }
            }
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        } else if ("clear".equalsIgnoreCase(action)) {
            cart.clear();
            session.removeAttribute("appliedPromoCode");
            session.removeAttribute("appliedDiscount");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        // 3. Recalculate discount if cart changed
        String appliedPromoCode = (String) session.getAttribute("appliedPromoCode");
        if (appliedPromoCode != null) {
            Promotion promo = promotionDAO.getPromotionByCode(appliedPromoCode);
            if (promo != null && (promo.getExpiryDate() == null || !promo.getExpiryDate().isBefore(LocalDate.now()))) {
                double itemsSubtotal = calculateCartSubtotal(cart);
                session.setAttribute("appliedDiscount", Math.max(0.0, itemsSubtotal - promo.applyDiscount(itemsSubtotal)));
            } else {
                session.removeAttribute("appliedPromoCode");
                session.removeAttribute("appliedDiscount");
            }
        }

        // 4. Forward to the Checkout Page
        request.getRequestDispatcher("/comp04-orders/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(true);
        @SuppressWarnings("unchecked")
        List<OrderItem> cart = (List<OrderItem>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            String singleProdId = ParamUtil.getTrimmed(request, "productId");
            if (singleProdId != null) {
                Product p = productDAO.getProductById(singleProdId);
                if (p != null) {
                    cart = new ArrayList<>();
                    cart.add(new OrderItem(p.getProductId(), p.getName(), 1, p.getPrice()));
                }
            }
        }

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/menu?error=empty_cart");
            return;
        }

        // 1. Resolve Customer Identity
        String customerId = SecurityUtil.resolveOrRegisterCustomer(request, userDAO, "Bakery Pickup");
        if (customerId == null) {
            response.sendRedirect(request.getContextPath() + "/comp01-user/login.jsp?redirect=checkout&error=unauthorized");
            return;
        }

        // 2. Order Configuration & Type
        String orderType = ParamUtil.getTrimmed(request, "orderType", "Pickup");
        String deliveryAddress = ParamUtil.getTrimmed(request, "deliveryAddress", "Address upon request");
        boolean isDelivery = "Delivery".equalsIgnoreCase(orderType);

        String orderCode = "ORD-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        Order order = isDelivery ? new DeliveryOrder(orderCode, customerId, deliveryAddress)
                : new PickupOrder(orderCode, customerId);

        for (OrderItem item : cart) {
            order.addItem(item);
        }

        Double appliedDiscount = (Double) session.getAttribute("appliedDiscount");
        String appliedPromoCode = (String) session.getAttribute("appliedPromoCode");
        if (appliedDiscount != null && appliedDiscount > 0) {
            order.setDiscount(appliedDiscount);
            order.setPromoCode(appliedPromoCode);
        }
        order.setStatus("Pending");

        // 3. Persist Order via DAO
        orderDAO.createOrder(order);

        // 4. Record Payment
        String paymentMethod = ParamUtil.getTrimmed(request, "paymentMethod", "CARD_SIMULATED");
        String paymentStatus = "COUNTER_CASH".equalsIgnoreCase(paymentMethod) ? "PENDING_AT_COUNTER" : "COMPLETED";
        orderDAO.recordPayment(order.getOrderId(), order.calculateFinalTotal(), paymentMethod, paymentStatus);

        // Enqueue into Kitchen Operations Queue
        try {
            LocalDateTime dueTime = LocalDateTime.now().plusHours(3);
            kitchenTaskDAO.enqueueOrderTask(-1, order.getOrderId(), dueTime, orderType, "Fresh Order via Online Checkout");
        } catch (Exception e) {
            System.err.println("Notice: Could not enqueue kitchen task: " + e.getMessage());
        }

        // 5. Clear Cart & Redirect to Success Screen
        session.removeAttribute("cart");
        session.removeAttribute("appliedPromoCode");
        session.removeAttribute("appliedDiscount");
        response.sendRedirect(request.getContextPath() + "/orderSuccess?orderId=" + order.getOrderId());
    }

    private double calculateCartSubtotal(List<OrderItem> cart) {
        double total = 0.0;
        if (cart != null) {
            for (OrderItem it : cart) total += it.getSubtotal();
        }
        return total;
    }
}
