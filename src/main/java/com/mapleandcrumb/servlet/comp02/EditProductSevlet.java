package com.mapleandcrumb.servlet.comp02;

import com.mapleandcrumb.dao.comp02.ProductDAO;
import com.mapleandcrumb.dao.impl.comp02.ProductDAOImpl;
import com.mapleandcrumb.model.comp02.Product;
import com.mapleandcrumb.model.comp02.StandardCake;
import com.mapleandcrumb.model.comp02.StandardPastry;
import com.mapleandcrumb.util.ParamUtil;
import com.mapleandcrumb.util.SecurityUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet({ "/editProduct", "/comp02-products/editProduct" })
public class EditProductServlet extends HttpServlet {
    private final ProductDAO productDAO = new ProductDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!SecurityUtil.requireStaffOrAdmin(request, response)) {
            return;
        }

        String productId = ParamUtil.getTrimmed(request, "productId");
        if (productId == null) {
            response.sendRedirect(request.getContextPath() + "/manageProducts?error=invalid_id");
            return;
        }

        Product product = productDAO.getProductById(productId);
        if (product == null) {
            response.sendRedirect(request.getContextPath() + "/manageProducts?error=notfound");
            return;
        }

        request.setAttribute("product", product);
        if (product instanceof StandardCake) {
            StandardCake cake = (StandardCake) product;
            request.setAttribute("isCake", true);
            request.setAttribute("flavor", cake.getFlavor());
            request.setAttribute("sizeInches", cake.getSizeInches());
        } else if (product instanceof StandardPastry) {
            StandardPastry pastry = (StandardPastry) product;
            request.setAttribute("isCake", false);
            request.setAttribute("containsNuts", pastry.isContainsNuts());
        }

        request.getRequestDispatcher("/comp02-products/edit_product.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!SecurityUtil.requireStaffOrAdmin(request, response)) {
            return;
        }

        String productId = ParamUtil.getTrimmed(request, "productId");
        String name = ParamUtil.getTrimmed(request, "name");
        String category = ParamUtil.getTrimmed(request, "category");
        String priceStr = ParamUtil.getTrimmed(request, "price");
        String stockStr = ParamUtil.getTrimmed(request, "stockQuantity");

        if (productId == null || name == null || category == null || priceStr == null || stockStr == null) {
            response.sendRedirect(request.getContextPath() + "/comp02-products/editProduct?productId=" + (productId != null ? productId : "") + "&error=invalid");
            return;
        }

        double price;
        int stock;
        try {
            price = Double.parseDouble(priceStr);
            stock = Integer.parseInt(stockStr);
            if (price < 0 || stock < 0) {
                response.sendRedirect(request.getContextPath() + "/comp02-products/editProduct?productId=" + productId + "&error=invalid");
                return;
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/comp02-products/editProduct?productId=" + productId + "&error=invalid");
            return;
        }

        String flavor = ParamUtil.getTrimmed(request, "flavor", "Artisan Vanilla");
        int sizeInches = ParamUtil.getInt(request, "sizeInches", 8);
        boolean containsNuts = ParamUtil.getBoolean(request, "containsNuts");

        Product product = Product.create(productId, name, category, price, stock, flavor, sizeInches, containsNuts);
        productDAO.updateProduct(product);
        response.sendRedirect(request.getContextPath() + "/manageProducts?msg=updated");
    }
}