package com.mapleandcrumb.servlet.comp02;

import com.mapleandcrumb.dao.ProductDAO;
import com.mapleandcrumb.dao.impl.ProductDAOImpl;
import com.mapleandcrumb.model.StandardCake;
import com.mapleandcrumb.model.StandardPastry;
import com.mapleandcrumb.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.UUID;

@WebServlet({"/addProduct", "/comp02-products/addProduct"})
public class AddProductServlet extends HttpServlet {
    private ProductDAO productDAO = new ProductDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = session != null ? (User) session.getAttribute("loggedInUser") : null;

        if (currentUser == null || (!"ADMIN".equals(currentUser.getUserRole()) && !"STAFF".equals(currentUser.getUserRole()))) {
            response.sendRedirect(request.getContextPath() + "/comp01-user/login.jsp?error=unauthorized");
            return;
        }

        request.getRequestDispatcher("/comp02-products/add_product.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = session != null ? (User) session.getAttribute("loggedInUser") : null;

        // Security check: Only Admin or Staff can add products
        if (currentUser == null || (!"ADMIN".equals(currentUser.getUserRole()) && !"STAFF".equals(currentUser.getUserRole()))) {
            response.sendRedirect(request.getContextPath() + "/comp01-user/login.jsp?error=unauthorized");
            return;
        }

        String name = request.getParameter("name");
        String category = request.getParameter("category");
        String priceStr = request.getParameter("price");
        String stockStr = request.getParameter("stockQuantity");

        // Input validation
        if (name == null || name.trim().isEmpty() || category == null || category.trim().isEmpty()
                || priceStr == null || stockStr == null) {
            response.sendRedirect(request.getContextPath() + "/comp02-products/add_product.jsp?error=invalid");
            return;
        }

        double price;
        int stockQuantity;
        try {
            price = Double.parseDouble(priceStr.trim());
            stockQuantity = Integer.parseInt(stockStr.trim());
            if (price <= 0 || stockQuantity < 0) {
                response.sendRedirect(request.getContextPath() + "/comp02-products/add_product.jsp?error=invalid");
                return;
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/comp02-products/add_product.jsp?error=invalid");
            return;
        }

        String productId = "P" + UUID.randomUUID().toString().substring(0, 5).toUpperCase();

        if ("Cake".equalsIgnoreCase(category.trim())) {
            String flavor = request.getParameter("flavor");
            if (flavor == null || flavor.trim().isEmpty()) {
                flavor = "Standard";
            }
            int sizeInches = 8;
            String sizeStr = request.getParameter("sizeInches");
            if (sizeStr != null && !sizeStr.trim().isEmpty()) {
                try {
                    sizeInches = Integer.parseInt(sizeStr.trim());
                } catch (NumberFormatException ignored) {}
            }
            StandardCake cake = new StandardCake(productId, name.trim(), price, stockQuantity, flavor.trim(), sizeInches);
            productDAO.addProduct(cake);
        } else {
            String containsNutsVal = request.getParameter("containsNuts");
            boolean containsNuts = "true".equalsIgnoreCase(containsNutsVal) || "on".equalsIgnoreCase(containsNutsVal);
            StandardPastry pastry = new StandardPastry(productId, name.trim(), price, stockQuantity, containsNuts);
            productDAO.addProduct(pastry);
        }

        response.sendRedirect(request.getContextPath() + "/comp02-products/manage_products.jsp?msg=added");
    }
}