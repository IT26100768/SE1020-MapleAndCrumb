package com.mapleandcrumb.servlet.comp03;

import com.mapleandcrumb.dao.comp03.CustomCakeDAO;
import com.mapleandcrumb.dao.impl.comp03.CustomCakeDAOImpl;
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
import java.util.List;

@WebServlet({
    "/viewBookings",
    "/myBookings",
    "/my_bookings",
    "/manageBookings",
    "/manage_bookings",
    "/comp03-bookings/viewBookings",
    "/comp03-bookings/myBookings",
    "/comp03-bookings/manageBookings"
})
public class ViewBookingsServlet extends HttpServlet {

    private final CustomCakeDAO customCakeDAO = new CustomCakeDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = SecurityUtil.getLoggedInUser(request);
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/comp01-user/login.jsp?error=unauthorized");
            return;
        }

        String servletPath = request.getServletPath();
        String viewParam = ParamUtil.getTrimmed(request, "view");
        boolean isAdminOrStaff = SecurityUtil.isStaffOrAdmin(currentUser);
        boolean isExplicitMy = servletPath.contains("my") || "my".equalsIgnoreCase(viewParam);
        boolean isManagement = servletPath.contains("manage") || "all".equalsIgnoreCase(viewParam) || "manage".equalsIgnoreCase(viewParam)
                || (isAdminOrStaff && !isExplicitMy);

        if (isManagement) {
            if (!isAdminOrStaff) {
                response.sendRedirect(request.getContextPath() + "/comp01-user/login.jsp?error=unauthorized");
                return;
            }
            request.setAttribute("bookings", customCakeDAO.getAllBookings());
            request.getRequestDispatcher("/comp03-bookings/manage_bookings.jsp").forward(request, response);
            return;
        }

        // Customer's personal bookings view
        List<CustomCakeOrder> bookings = customCakeDAO.getBookingsByCustomer(currentUser.getUserID());
        if (bookings.isEmpty() && currentUser.getEmail() != null) {
            bookings = customCakeDAO.getBookingsByCustomer(currentUser.getEmail());
        }
        if (bookings.isEmpty() && currentUser.getUsername() != null) {
            bookings = customCakeDAO.getBookingsByCustomer(currentUser.getUsername());
        }

        request.setAttribute("bookings", bookings);
        request.getRequestDispatcher("/comp03-bookings/my_bookings.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
