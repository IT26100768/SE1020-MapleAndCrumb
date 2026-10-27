package com.mapleandcrumb.servlet.comp06;

import com.mapleandcrumb.dao.comp06.PromotionDAO;
import com.mapleandcrumb.dao.impl.comp06.PromotionDAOImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet({ "/promotions", "/comp06-reviews/promotions", "/comp06-promotions/promotions" })
public class PromotionsServlet extends HttpServlet {

    private final PromotionDAO promotionDAO = new PromotionDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("activePromotions", promotionDAO.getAllActivePromotions());
        request.getRequestDispatcher("/comp06-reviews/promotions.jsp").forward(request, response);
    }
}

