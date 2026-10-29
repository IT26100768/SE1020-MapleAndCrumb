package com.mapleandcrumb.dao.comp04;

import com.mapleandcrumb.model.comp04.Order;

import java.util.List;
import java.util.Map;

public interface OrderDAO {

    void createOrder(Order order);

    Order getOrderById(String orderId);

    List<Order> getOrdersByCustomer(String customerId);

    List<Order> getAllOrders();

    int getOrderCount();

    void updateOrder(Order order);

    void updateOrderStatus(String orderId, String newStatus);

    void cancelOrder(String orderId);

    void recordPayment(String orderId, double amount, String paymentMethod, String status);

    String getPaymentMethod(String orderId);

    double getTodayRevenue();

    double getYesterdayRevenue();

    int getTodayOrderCount();

    int getTodayOrderCountByType(String orderType);

    Map<String, Double> getDailyRevenueLast7Days();
}