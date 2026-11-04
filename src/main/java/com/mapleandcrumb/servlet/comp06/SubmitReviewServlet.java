package com.mapleandcrumb.servlet.comp06;

import com.mapleandcrumb.dao.comp02.ProductDAO;
import com.mapleandcrumb.dao.comp06.ReviewDAO;
import com.mapleandcrumb.dao.impl.comp02.ProductDAOImpl;
import com.mapleandcrumb.dao.impl.comp06.ReviewDAOImpl;
import com.mapleandcrumb.model.comp01.User;
import com.mapleandcrumb.model.comp02.Product;
import com.mapleandcrumb.model.comp06.Review;
import com.mapleandcrumb.util.ParamUtil;
import com.mapleandcrumb.util.SecurityUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.UUID;

@WebServlet({ "/submitReview", "/comp06-reviews/submitReview", "/submit_review" })
public class SubmitReviewServlet extends HttpServlet {

    private final ReviewDAO reviewDAO = new ReviewDAOImpl();
    private final ProductDAO productDAO = new ProductDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String productId = ParamUtil.getTrimmed(request, "productId");
        if (productId != null) {
            response.sendRedirect(request.getContextPath() + "/viewReviews?productId="
                    + URLEncoder.encode(productId, StandardCharsets.UTF_8));
        } else {
            response.sendRedirect(request.getContextPath() + "/viewReviews");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = SecurityUtil.getLoggedInUser(request);
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/comp01-user/login.jsp?redirect=viewReviews&error=unauthorized");
            return;
        }

        String productId = ParamUtil.getTrimmed(request, "productId");
        int rating = ParamUtil.getInt(request, "rating", -1);
        String comment = ParamUtil.getTrimmed(request, "comment");

        if (productId == null || comment == null) {
            response.sendRedirect(request.getContextPath() + "/viewReviews?error=invalidInput");
            return;
        }

        if (rating < 1 || rating > 5) {
            response.sendRedirect(request.getContextPath() + "/viewReviews?productId="
                    + URLEncoder.encode(productId, StandardCharsets.UTF_8) + "&error=invalidRating");
            return;
        }

        Product product = productDAO.getProductById(productId);
        if (product == null) {
            response.sendRedirect(request.getContextPath() + "/viewReviews?error=productNotFound");
            return;
        }

        String reviewCode = "REV-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        String customerIdentifier = (currentUser.getUserID() != null && !currentUser.getUserID().isEmpty())
                ? currentUser.getUserID()
                : currentUser.getUsername();

        reviewDAO.addReview(new Review(reviewCode, customerIdentifier, product.getProductId(), rating, comment));

        response.sendRedirect(request.getContextPath() + "/viewReviews?productId="
                + URLEncoder.encode(productId, StandardCharsets.UTF_8) + "&msg=reviewSubmitted");
    }
}
