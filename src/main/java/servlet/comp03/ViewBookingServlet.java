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
import java.util.List;

@WebServlet({"/viewBookings", "/myBookings", "/comp03-custom-cakes/viewBookings"})
public class ViewBookingsServlet extends HttpServlet {
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

        List<CustomCakeOrder> bookings;
        if ("ADMIN".equals(currentUser.getUserRole()) || "STAFF".equals(currentUser.getUserRole())) {
            bookings = customCakeDAO.getAllBookings();
        } else {
            bookings = customCakeDAO.getBookingsByCustomer(currentUser.getUserID());
        }

        request.setAttribute("bookings", bookings);
        request.getRequestDispatcher("/comp03-custom-cakes/view_bookings.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
