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

@WebServlet({"/updateBookingStatus", "/comp03-custom-cakes/updateBookingStatus"})
public class UpdateBookingStatusServlet extends HttpServlet {
    private CustomCakeDAO customCakeDAO = new CustomCakeDAOImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = session != null ? (User) session.getAttribute("loggedInUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/comp01-user/login.jsp?error=loginRequired");
            return;
        }

        String bookingId = request.getParameter("bookingId");
        String status = request.getParameter("status");

        if (bookingId == null || bookingId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/viewBookings?error=invalid");
            return;
        }

        CustomCakeOrder booking = customCakeDAO.getBookingById(bookingId.trim());
        if (booking == null) {
            response.sendRedirect(request.getContextPath() + "/viewBookings?error=notFound");
            return;
        }

        boolean isStaffOrAdmin = "ADMIN".equals(currentUser.getUserRole()) || "STAFF".equals(currentUser.getUserRole());

        if (isStaffOrAdmin) {
            if (status != null && !status.trim().isEmpty()) {
                customCakeDAO.updateBookingStatus(bookingId.trim(), status.trim());
            }
        } else {
            // Customer ownership check: customers can only cancel their OWN pending booking
            if (!booking.getCustomerId().equals(currentUser.getUserID())) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Unauthorized modification attempt");
                return;
            }

            if ("Cancelled".equalsIgnoreCase(status) || "cancel".equalsIgnoreCase(request.getParameter("action"))) {
                if ("Pending".equalsIgnoreCase(booking.getStatus())) {
                    customCakeDAO.updateBookingStatus(bookingId.trim(), "Cancelled");
                } else {
                    response.sendRedirect(request.getContextPath() + "/viewBookings?error=cannotCancel");
                    return;
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/viewBookings?msg=statusUpdated");
    }
}
