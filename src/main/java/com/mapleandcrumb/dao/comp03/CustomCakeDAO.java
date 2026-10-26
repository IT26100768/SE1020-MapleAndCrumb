package com.mapleandcrumb.dao.comp03;

import com.mapleandcrumb.model.comp03.CustomCakeOrder;

import java.util.List;

public interface CustomCakeDAO {

    void createBooking(CustomCakeOrder booking);

    CustomCakeOrder getBookingById(String bookingId);

    List<CustomCakeOrder> getAllBookings();

    int getBookingCount();

    void updateBooking(CustomCakeOrder booking);

    void updateBookingStatus(String bookingId, String newStatus);

    void cancelBooking(String bookingId);

    List<CustomCakeOrder> getBookingsByCustomer(String customerId);
}

