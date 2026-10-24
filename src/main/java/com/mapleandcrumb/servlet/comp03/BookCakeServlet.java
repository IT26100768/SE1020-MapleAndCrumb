package com.mapleandcrumb.servlet.comp03;

import com.mapleandcrumb.dao.comp01.UserDAO;
import com.mapleandcrumb.dao.comp03.CustomCakeDAO;
import com.mapleandcrumb.dao.comp05.KitchenTaskDAO;
import com.mapleandcrumb.dao.impl.comp01.UserDAOImpl;
import com.mapleandcrumb.dao.impl.comp03.CustomCakeDAOImpl;
import com.mapleandcrumb.dao.impl.comp05.KitchenTaskDAOImpl;
import com.mapleandcrumb.model.comp03.CustomCakeOrder;
import com.mapleandcrumb.util.ParamUtil;
import com.mapleandcrumb.util.SecurityUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.UUID;

@WebServlet({"/bookCake", "/book_cake", "/comp03-bookings/bookCake", "/comp03-bookings/book_cake"})
public class BookCakeServlet extends HttpServlet {

    private final CustomCakeDAO customCakeDAO = new CustomCakeDAOImpl();
    private final UserDAO userDAO = new UserDAOImpl();
    private final KitchenTaskDAO kitchenTaskDAO = new KitchenTaskDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/comp03-bookings/book_cake.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String customerId = SecurityUtil.resolveOrRegisterCustomer(request, userDAO, "Bakery Pickup Counter");
        if (customerId == null) {
            response.sendRedirect(request.getContextPath() + "/comp01-user/login.jsp?error=unauthorized&redirect=bookCake");
            return;
        }

        String flavor = ParamUtil.getTrimmed(request, "flavor", "Belgian Chocolate Truffle");
        String sizeStr = ParamUtil.getTrimmed(request, "size");
        if (sizeStr == null) {
            sizeStr = ParamUtil.getTrimmed(request, "sizeInches");
        }
        int sizeInches = 8;
        if (sizeStr != null) {
            try {
                sizeInches = Integer.parseInt(sizeStr.replaceAll("[^0-9]", ""));
                if (sizeInches <= 0) sizeInches = 8;
            } catch (NumberFormatException ignored) {
            }
        }

        String customMessage = ParamUtil.getTrimmed(request, "customMessage");
        String occasion = ParamUtil.getTrimmed(request, "occasion");
        String pickupDateStr = ParamUtil.getTrimmed(request, "pickupDate");
        String pickupTime = ParamUtil.getTrimmed(request, "pickupTime");
        String specialNotes = ParamUtil.getTrimmed(request, "specialNotes");
        String orderType = ParamUtil.getTrimmed(request, "orderType", "Pickup");
        String deliveryAddress = ParamUtil.getTrimmed(request, "deliveryAddress");
        boolean isDelivery = "Delivery".equalsIgnoreCase(orderType);

        LocalDate pickupDate = LocalDate.now().plusDays(2);
        if (pickupDateStr != null) {
            try {
                pickupDate = LocalDate.parse(pickupDateStr);
            } catch (DateTimeParseException ignored) {
            }
        }

        StringBuilder designDetails = new StringBuilder();
        if (customMessage != null && !customMessage.isEmpty()) designDetails.append(customMessage);
        if (occasion != null && !occasion.isEmpty()) {
            if (designDetails.length() > 0) designDetails.append(" | ");
            designDetails.append("Occasion: ").append(occasion);
        }
        if (pickupTime != null && !pickupTime.isEmpty()) {
            if (designDetails.length() > 0) designDetails.append(" | ");
            designDetails.append("Time Slot: ").append(pickupTime);
        }
        if (isDelivery) {
            if (designDetails.length() > 0) designDetails.append(" | ");
            designDetails.append("Fulfillment: Doorstep Delivery");
            if (deliveryAddress != null && !deliveryAddress.isEmpty()) {
                designDetails.append(" [Dest: ").append(deliveryAddress).append("]");
            }
        } else {
            if (designDetails.length() > 0) designDetails.append(" | ");
            designDetails.append("Fulfillment: Bakery Counter Pickup");
        }
        if (specialNotes != null && !specialNotes.isEmpty()) {
            if (designDetails.length() > 0) designDetails.append(" | Notes: ").append(specialNotes);
        }

        String bookingId = "BK-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        CustomCakeOrder booking = new CustomCakeOrder(bookingId, customerId, pickupDate);
        booking.selectFlavor(flavor);
        booking.selectSize(sizeInches);
        booking.addCustomMessage(designDetails.toString());
        booking.setStatus("Pending");

        double basePrice = booking.calculateBasePrice();
        double totalPrice = isDelivery ? basePrice + 500.00 : basePrice;
        booking.setQuotedPrice(totalPrice);

        customCakeDAO.createBooking(booking);

        try {
            kitchenTaskDAO.enqueueCakeTask(-1, bookingId, pickupDate, pickupTime, designDetails.toString());
        } catch (Exception e) {
            System.err.println("Notice: Could not enqueue custom cake kitchen task: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/myBookings?msg=booked&id=" + bookingId);
    }
}
