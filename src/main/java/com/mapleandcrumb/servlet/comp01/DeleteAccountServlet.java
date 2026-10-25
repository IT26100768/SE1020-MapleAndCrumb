package com.mapleandcrumb.servlet.comp01;

import com.mapleandcrumb.dao.comp01.UserDAO;
import com.mapleandcrumb.dao.impl.comp01.UserDAOImpl;
import com.mapleandcrumb.model.comp01.User;
import com.mapleandcrumb.util.ParamUtil;
import com.mapleandcrumb.util.SecurityUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet({"/deleteAccount", "/comp01-user/deleteAccount"})
public class DeleteAccountServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/comp01-user/profile.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = SecurityUtil.getLoggedInUser(request);
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/comp01-user/login.jsp?error=unauthorized");
            return;
        }

        if (SecurityUtil.isAdmin(currentUser)) {
            response.sendRedirect(request.getContextPath() + "/comp01-user/profile.jsp?error=adminCannotDelete");
            return;
        }

        String password = ParamUtil.getTrimmed(request, "password");
        if (password == null) {
            response.sendRedirect(request.getContextPath() + "/comp01-user/profile.jsp?error=passwordRequired");
            return;
        }

        User dbUser = userDAO.searchUserById(currentUser.getUserID());
        if (dbUser == null && currentUser.getEmail() != null) {
            dbUser = userDAO.searchUserByEmail(currentUser.getEmail());
        }

        if (dbUser == null) {
            response.sendRedirect(request.getContextPath() + "/comp01-user/profile.jsp?error=deleteFailed");
            return;
        }

        String storedPassword = dbUser.getPassword();
        boolean passwordMatches = storedPassword != null &&
                (storedPassword.equals(password) || storedPassword.equals(password.trim()));

        if (!passwordMatches) {
            response.sendRedirect(request.getContextPath() + "/comp01-user/profile.jsp?error=wrongPassword");
            return;
        }

        boolean deleted = userDAO.deleteUser(dbUser.getUserID());
        if (!deleted && currentUser.getUserID() != null && !currentUser.getUserID().equals(dbUser.getUserID())) {
            deleted = userDAO.deleteUser(currentUser.getUserID());
        }
        if (!deleted && dbUser.getEmail() != null) {
            deleted = userDAO.deleteUser(dbUser.getEmail());
        }

        if (deleted) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.removeAttribute("loggedInUser");
                session.removeAttribute("cart");
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/comp01-user/login.jsp?msg=accountDeleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/comp01-user/profile.jsp?error=deleteFailed");
        }
    }
}
