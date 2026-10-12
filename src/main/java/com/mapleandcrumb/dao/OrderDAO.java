package com.mapleandcrumb.dao;

import com.mapleandcrumb.model.Order;

import java.util.List;

public interface OrderDAO {

    void createOrder(Order order);

    Order getOrderById(String orderId);

    List<Order> getOrdersByCustomer(String customerId);

    List<Order> getAllOrders();

    void updateOrder(Order order);

    void updateOrderStatus(String orderId, String newStatus);

    void cancelOrder(String orderId);
}
