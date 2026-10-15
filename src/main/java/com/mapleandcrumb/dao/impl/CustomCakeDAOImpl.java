package com.mapleandcrumb.dao.impl;

import com.mapleandcrumb.dao.CustomCakeDAO;
import com.mapleandcrumb.model.CustomCakeOrder;
import com.mapleandcrumb.util.FileUtil;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class CustomCakeDAOImpl implements CustomCakeDAO {
    private static final String FILE_NAME = "custom_cakes.txt";
    // Format: bookingId,customerId,flavor,size,message,pickupDate,status

    @Override
    public void createBooking(CustomCakeOrder booking) {
        String line = booking.getBookingId() + "," + booking.getCustomerId() + "," + booking.getFlavor() + ","
                + booking.getSizeInches() + "," + booking.getCustomMessage() + ","
                + booking.getPickupDate() + "," + booking.getStatus();
        FileUtil.appendToFile(FILE_NAME, line);
    }

    @Override
    public CustomCakeOrder getBookingById(String bookingId) {
        for (String line : FileUtil.readFromFile(FILE_NAME)) {
            String[] d = line.split(",");
            if (d.length > 0 && d[0].equals(bookingId)) return mapLineToBooking(d);
        }
        return null;
    }

    @Override
    public List<CustomCakeOrder> getBookingsByCustomer(String customerId) {
        List<CustomCakeOrder> list = new ArrayList<>();
        for (String line : FileUtil.readFromFile(FILE_NAME)) {
            String[] d = line.split(",");
            if (d.length > 1 && d[1].equals(customerId)) list.add(mapLineToBooking(d));
        }
        return list;
    }

    @Override
    public List<CustomCakeOrder> getAllBookings() {
        List<CustomCakeOrder> list = new ArrayList<>();
        for (String line : FileUtil.readFromFile(FILE_NAME)) {
            if(!line.trim().isEmpty()) list.add(mapLineToBooking(line.split(",")));
        }
        return list;
    }

    @Override
    public void updateBooking(CustomCakeOrder booking) {
        cancelBooking(booking.getBookingId());
        createBooking(booking);
    }

    @Override
    public void updateBookingStatus(String bookingId, String newStatus) {
        CustomCakeOrder booking = getBookingById(bookingId);
        if (booking != null) {
            booking.setStatus(newStatus);
            updateBooking(booking);
        }
    }

    @Override
    public void cancelBooking(String bookingId) {
        List<String> lines = FileUtil.readFromFile(FILE_NAME);
        List<String> updated = new ArrayList<>();
        for (String line : lines) {
            if (!line.startsWith(bookingId + ",")) updated.add(line);
        }
        FileUtil.writeToFile(FILE_NAME, updated);
    }

    private CustomCakeOrder mapLineToBooking(String[] d) {
        CustomCakeOrder order = new CustomCakeOrder(d[0], d[1], LocalDate.parse(d[5]));
        order.selectFlavor(d[2]);
        order.selectSize(Integer.parseInt(d[3]));
        order.addCustomMessage(d[4]);
        order.setStatus(d[6]);
        return order;
    }
}


