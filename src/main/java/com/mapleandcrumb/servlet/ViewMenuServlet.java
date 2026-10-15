package com.mapleandcrumb.servlet.comp02;

import com.mapleandcrumb.dao.ProductDAO;
import com.mapleandcrumb.dao.impl.ProductDAOImpl;
import com.mapleandcrumb.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet({"/menu", "/products", "/manageProducts"})
public class ViewMenuServlet extends HttpServlet {
    private ProductDAO productDAO = new ProductDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String category = request.getParameter("category");
        String query = request.getParameter("query");

        List<Product> products;
        if (category != null && !category.trim().isEmpty() && !"ALL".equalsIgnoreCase(category.trim())) {
            products = productDAO.searchByCategory(category.trim());
        } else if (query != null && !query.trim().isEmpty()) {
            products = productDAO.searchByName(query.trim());
        } else {
            products = productDAO.getAllProducts();
        }

        request.setAttribute("products", products);

        String servletPath = request.getServletPath();
        String view = request.getParameter("view");
        if ("/manageProducts".equalsIgnoreCase(servletPath) || "manage".equalsIgnoreCase(view)) {
            request.getRequestDispatcher("/comp02-products/manage_products.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/comp02-products/menu.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

