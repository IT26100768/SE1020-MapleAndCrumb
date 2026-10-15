package com.mapleandcrumb.servlet.comp03;

import com.mapleandcrumb.dao.CustomCakeDAO;
import com.mapleandcrumb.dao.impl.CustomCakeDAOImpl;
import com.mapleandcrumb.model.CustomCakeOrder;
import com.mapleandcrumb.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.util.UUID;

@WebServlet({"/bookCake", "/comp03-custom-cakes/bookCake"})
public class BookCakeServlet extends HttpServlet {
    private CustomCakeDAO customCakeDAO = new CustomCakeDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = session != null ? (User) session.getAttribute("loggedInUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/comp01-user/login.jsp?error=loginRequired");
            return;
        }

        request.getRequestDispatcher("/comp03-custom-cakes/book_cake.jsp").forward(request, response);
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

        String flavor = request.getParameter("flavor");
        String sizeStr = request.getParameter("sizeInches");
        if (sizeStr == null || sizeStr.trim().isEmpty()) {
            sizeStr = request.getParameter("size");
        }
        String customMessage = request.getParameter("customMessage");
        if (customMessage == null) {
            customMessage = request.getParameter("message");
        }
        String pickupDateStr = request.getParameter("pickupDate");

        if (flavor == null || flavor.trim().isEmpty() || sizeStr == null || sizeStr.trim().isEmpty()
                || pickupDateStr == null || pickupDateStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/comp03-custom-cakes/book_cake.jsp?error=invalid");
            return;
        }

        int sizeInches;
        LocalDate pickupDate;
        try {
            sizeInches = Integer.parseInt(sizeStr.trim());
            pickupDate = LocalDate.parse(pickupDateStr.trim());
            if (sizeInches <= 0 || pickupDate.isBefore(LocalDate.now())) {
                response.sendRedirect(request.getContextPath() + "/comp03-custom-cakes/book_cake.jsp?error=invalid");
                return;
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/comp03-custom-cakes/book_cake.jsp?error=invalid");
            return;
        }

        String bookingId = "BK" + UUID.randomUUID().toString().substring(0, 5).toUpperCase();
        // Ownership check: Always assign booking to authenticated user
        CustomCakeOrder booking = new CustomCakeOrder(bookingId, currentUser.getUserID(), pickupDate);
        booking.selectFlavor(flavor.trim());
        booking.selectSize(sizeInches);
        booking.addCustomMessage(customMessage != null ? customMessage.trim() : "");

        customCakeDAO.createBooking(booking);

        response.sendRedirect(request.getContextPath() + "/viewBookings?msg=booked");
    }
}
