package com.mapleandcrumb.servlet.comp02;

import com.mapleandcrumb.dao.ProductDAO;
import com.mapleandcrumb.dao.impl.ProductDAOImpl;
import com.mapleandcrumb.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/deleteProduct")
public class DeleteProductServlet extends HttpServlet {
    private ProductDAO productDAO = new ProductDAOImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = session != null ? (User) session.getAttribute("loggedInUser") : null;

        // Security check: Only Admin or Staff can delete products
        if (currentUser == null || (!"ADMIN".equals(currentUser.getUserRole()) && !"STAFF".equals(currentUser.getUserRole()))) {
            response.sendRedirect(request.getContextPath() + "/comp01-user/login.jsp?error=unauthorized");
            return;
        }

        String productId = request.getParameter("productId");
        if (productId != null && !productId.trim().isEmpty()) {
            productDAO.deleteProduct(productId.trim());
            response.sendRedirect(request.getContextPath() + "/comp02-products/manage_products.jsp?msg=deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/comp02-products/manage_products.jsp?error=invalid");
        }
    }
}