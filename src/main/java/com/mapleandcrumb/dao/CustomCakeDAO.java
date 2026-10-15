package com.mapleandcrumb.dao;

import com.mapleandcrumb.model.CustomCakeOrder;
import java.util.List;

public interface CustomCakeDAO {

    void createBooking(CustomCakeOrder booking);

    CustomCakeOrder getBookingById(String bookingId);

    List<CustomCakeOrder> getBookingsByCustomer(String customerId);

    List<CustomCakeOrder> getAllBookings();

    void updateBooking(CustomCakeOrder booking);

    void updateBookingStatus(String bookingId, String newStatus);

    void cancelBooking(String bookingId);

}