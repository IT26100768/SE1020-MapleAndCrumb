package com.mapleandcrumb.dao.impl;

import com.mapleandcrumb.dao.OrderDAO;
import com.mapleandcrumb.model.*;
import com.mapleandcrumb.util.FileUtil;
import java.util.ArrayList;
import java.util.List;

public class OrderDAOImpl implements OrderDAO {
    private static final String FILE_NAME = "orders.txt";


    @Override
    public void createOrder(Order order) {
        String type = (order instanceof DeliveryOrder) ? "Delivery" : "Pickup";
        String address = (order instanceof DeliveryOrder) ? ((DeliveryOrder) order).getDeliveryAddress() : "N/A";

        StringBuilder itemsStr = new StringBuilder();
        for (OrderItem item : order.getItems()) {
            itemsStr.append(item.getProductId()).append(":")
                    .append(item.getProductName()).append(":")
                    .append(item.getQuantity()).append(":")
                    .append(item.getUnitPrice()).append(";");
        }

        String line = order.getOrderId() + "," + order.getCustomerId() + "," + order.getStatus() + ","
                + type + "," + address + "," + itemsStr.toString();
        FileUtil.appendToFile(FILE_NAME, line);
    }

    @Override
    public Order getOrderById(String orderId) {
        for (String line : FileUtil.readFromFile(FILE_NAME)) {
            String[] d = line.split(",", 6);
            if (d[0].equals(orderId)) return mapLineToOrder(d);
        }
        return null;
    }

    @Override
    public List<Order> getOrdersByCustomer(String customerId) {
        List<Order> list = new ArrayList<>();
        for (String line : FileUtil.readFromFile(FILE_NAME)) {
            String[] d = line.split(",", 6);
            if (d[1].equals(customerId)) list.add(mapLineToOrder(d));
        }
        return list;
    }

    @Override
    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        for (String line : FileUtil.readFromFile(FILE_NAME)) {
            if(!line.trim().isEmpty()) list.add(mapLineToOrder(line.split(",", 6)));
        }
        return list;
    }

    @Override
    public void updateOrder(Order order) {
        cancelOrder(order.getOrderId());
        createOrder(order);
    }

    @Override
    public void updateOrderStatus(String orderId, String newStatus) {
        Order order = getOrderById(orderId);
        if (order != null) {
            order.setStatus(newStatus);
            updateOrder(order);
        }
    }

    @Override
    public void cancelOrder(String orderId) {
        List<String> lines = FileUtil.readFromFile(FILE_NAME);
        List<String> updated = new ArrayList<>();
        for (String line : lines) {
            if (!line.startsWith(orderId + ",")) updated.add(line);
        }
        FileUtil.writeToFile(FILE_NAME, updated);
    }


    private Order mapLineToOrder(String[] d) {
        Order order;
        if (d[3].equals("Delivery")) {
            order = new DeliveryOrder(d[0], d[1], d[4]);
        } else {
            order = new PickupOrder(d[0], d[1]);
        }
        order.setStatus(d[2]);


        if (d.length > 5 && !d[5].isEmpty()) {
            String[] itemsArray = d[5].split(";");
            for (String itemStr : itemsArray) {
                if(!itemStr.isEmpty()) {
                    String[] itemData = itemStr.split(":");
                    order.addItem(new OrderItem(itemData[0], itemData[1], Integer.parseInt(itemData[2]), Double.parseDouble(itemData[3])));
                }
            }
        }
        return order;
    }
}


