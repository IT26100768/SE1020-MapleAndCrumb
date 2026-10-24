package com.mapleandcrumb.servlet.comp02;

import com.mapleandcrumb.dao.comp02.ProductDAO;
import com.mapleandcrumb.dao.impl.comp02.ProductDAOImpl;
import com.mapleandcrumb.model.comp02.Product;
import com.mapleandcrumb.util.ParamUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet({"/menu", "/comp02-products/menu"})
public class MenuServlet extends HttpServlet {
    private final ProductDAO productDAO = new ProductDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String category = ParamUtil.getTrimmed(request, "category");
        String search = ParamUtil.getTrimmed(request, "search");
        if (search == null) {
            search = ParamUtil.getTrimmed(request, "query");
        }
        if (search == null) {
            search = ParamUtil.getTrimmed(request, "name");
        }

        List<Product> allProducts = productDAO.getAllProducts();
        List<Product> filteredProducts = new ArrayList<>();

        boolean hasCategoryFilter = (category != null && !"ALL".equalsIgnoreCase(category));
        boolean hasSearchFilter = (search != null);
        String searchLower = hasSearchFilter ? search.toLowerCase() : "";

        for (Product product : allProducts) {
            boolean matchesCategory = !hasCategoryFilter || product.getCategory().equalsIgnoreCase(category);
            boolean matchesSearch = !hasSearchFilter
                    || product.getName().toLowerCase().contains(searchLower)
                    || (product.getDisplayDescription() != null && product.getDisplayDescription().toLowerCase().contains(searchLower));

            if (matchesCategory && matchesSearch) {
                filteredProducts.add(product);
            }
        }

        request.setAttribute("products", filteredProducts);
        request.setAttribute("selectedCategory", (category != null) ? category : "ALL");
        request.setAttribute("searchQuery", (search != null) ? search : "");
        request.getRequestDispatcher("/comp02-products/menu.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}