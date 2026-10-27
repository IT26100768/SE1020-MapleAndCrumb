package com.mapleandcrumb.servlet.comp02;

import com.mapleandcrumb.dao.comp02.ProductDAO;
import com.mapleandcrumb.dao.impl.comp02.ProductDAOImpl;
import com.mapleandcrumb.util.ParamUtil;
import com.mapleandcrumb.util.SecurityUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet({ "/deleteProduct", "/comp02-products/deleteProduct" })
public class DeleteProductServlet extends HttpServlet {
    private final ProductDAO productDAO = new ProductDAOImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!SecurityUtil.requireStaffOrAdmin(request, response)) {
            return;
        }

        String productId = ParamUtil.getTrimmed(request, "productId");
        if (productId != null) {
            productDAO.deleteProduct(productId);
        }

        response.sendRedirect(request.getContextPath() + "/manageProducts?msg=deleted");
    }
}
