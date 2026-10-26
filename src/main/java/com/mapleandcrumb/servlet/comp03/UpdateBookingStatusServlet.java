package com.mapleandcrumb.servlet.comp03;

import com.mapleandcrumb.dao.comp03.CustomCakeDAO;
import com.mapleandcrumb.dao.comp05.KitchenTaskDAO;
import com.mapleandcrumb.dao.impl.comp03.CustomCakeDAOImpl;
import com.mapleandcrumb.dao.impl.comp05.KitchenTaskDAOImpl;
import com.mapleandcrumb.model.comp01.User;
import com.mapleandcrumb.model.comp03.CustomCakeOrder;
import com.mapleandcrumb.util.ParamUtil;
import com.mapleandcrumb.util.SecurityUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet({
        "/updateBookingStatus",
        "/cancelBooking",
        "/comp03-bookings/updateBookingStatus",
        "/comp03-bookings/cancelBooking"
})
public class UpdateBookingStatusServlet extends HttpServlet {

    private final CustomCakeDAO customCakeDAO = new CustomCakeDAOImpl();
    private final KitchenTaskDAO kitchenTaskDAO = new KitchenTaskDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = SecurityUtil.getLoggedInUser(request);
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/comp01-user/login.jsp?error=unauthorized");
            return;
        }

        String bookingId = ParamUtil.getTrimmed(request, "bookingId");
        if (bookingId == null) {
            bookingId = ParamUtil.getTrimmed(request, "id");
        }
        if (bookingId == null) {
            response.sendRedirect(request.getContextPath() + "/viewBookings?error=invalid");
            return;
        }

        String status = ParamUtil.getTrimmed(request, "status");
        if (status == null) {
            status = ParamUtil.getTrimmed(request, "newStatus");
        }

        String action = ParamUtil.getTrimmed(request, "action");
        String servletPath = request.getServletPath();
        if ("cancel".equalsIgnoreCase(action) || (servletPath != null && servletPath.contains("cancelBooking"))) {
            status = "Cancelled";
        }

        boolean isAdminOrStaff = SecurityUtil.isStaffOrAdmin(currentUser);
        CustomCakeOrder booking = customCakeDAO.getBookingById(bookingId);
        if (booking == null) {
            String redirectUrl = isAdminOrStaff ? "/manageBookings?error=notfound" : "/myBookings?error=notfound";
            response.sendRedirect(request.getContextPath() + redirectUrl);
            return;
        }

        if (isAdminOrStaff) {
            if (status != null) {
                customCakeDAO.updateBookingStatus(bookingId, status);
                kitchenTaskDAO.syncCakeStatus(bookingId, status);
                response.sendRedirect(request.getContextPath() + "/manageBookings?msg=statusUpdated");
            } else {
                response.sendRedirect(request.getContextPath() + "/manageBookings?error=invalid");
            }
        } else {
            if (SecurityUtil.isOwner(currentUser, booking.getCustomerId()) && "Cancelled".equalsIgnoreCase(status)) {
                customCakeDAO.cancelBooking(bookingId);
                kitchenTaskDAO.syncCakeStatus(bookingId, "Cancelled");
                response.sendRedirect(request.getContextPath() + "/myBookings?msg=cancelled");
            } else {
                response.sendRedirect(request.getContextPath() + "/myBookings?error=unauthorized");
            }
        }
    }
}