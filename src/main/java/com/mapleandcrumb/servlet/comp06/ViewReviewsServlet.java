package com.mapleandcrumb.servlet.comp06;

import com.mapleandcrumb.dao.comp02.ProductDAO;
import com.mapleandcrumb.dao.comp06.ReviewDAO;
import com.mapleandcrumb.dao.impl.comp02.ProductDAOImpl;
import com.mapleandcrumb.dao.impl.comp06.ReviewDAOImpl;
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
import java.util.ArrayList;
import java.util.List;

@WebServlet({ "/viewReviews", "/reviews", "/view_reviews", "/comp06-reviews/viewReviews", "/comp06-reviews/view_reviews" })
public class ViewReviewsServlet extends HttpServlet {

    private final ReviewDAO reviewDAO = new ReviewDAOImpl();
    private final ProductDAO productDAO = new ProductDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String productId = ParamUtil.getTrimmed(request, "productId");
        String ratingFilterStr = ParamUtil.getTrimmed(request, "rating");

        List<Product> products = productDAO.getAllProducts();
        boolean hasProductFilter = (productId != null && !"ALL".equalsIgnoreCase(productId));
        List<Review> rawReviews = hasProductFilter ? reviewDAO.getReviewsByProduct(productId) : reviewDAO.getAllReviews();

        int totalReviews = rawReviews.size();
        int[] counts = new int[6];
        int sumRating = 0;

        for (Review r : rawReviews) {
            int rating = r.getRating();
            sumRating += rating;
            if (rating >= 1 && rating <= 5) {
                counts[rating]++;
            }
        }

        double averageRating = totalReviews > 0 ? (double) sumRating / totalReviews : 5.0;
        averageRating = Math.round(averageRating * 10.0) / 10.0;

        Integer targetRating = (ratingFilterStr != null && !"ALL".equalsIgnoreCase(ratingFilterStr))
                ? ParamUtil.getInteger(request, "rating")
                : null;

        List<Review> displayedReviews = new ArrayList<>();
        for (Review r : rawReviews) {
            if (targetRating == null || r.getRating() == targetRating) {
                displayedReviews.add(r);
            }
        }

        request.setAttribute("reviews", displayedReviews);
        request.setAttribute("products", products);
        request.setAttribute("selectedProductId", (productId != null) ? productId : "ALL");
        request.setAttribute("selectedRating", targetRating != null ? String.valueOf(targetRating) : "ALL");
        request.setAttribute("totalReviews", totalReviews);
        request.setAttribute("averageRating", averageRating);

        for (int i = 1; i <= 5; i++) {
            request.setAttribute("count" + i + "Star", counts[i]);
            int pct = totalReviews > 0 ? (int) Math.round(((double) counts[i] / totalReviews) * 100) : 0;
            request.setAttribute("pct" + i + "Star", pct);
        }

        request.getRequestDispatcher("/comp06-reviews/view_reviews.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = ParamUtil.getTrimmed(request, "action");
        if ("delete".equalsIgnoreCase(action)) {
            if (!SecurityUtil.requireStaffOrAdmin(request, response)) {
                return;
            }
            String reviewId = ParamUtil.getTrimmed(request, "reviewId");
            if (reviewId != null) {
                reviewDAO.deleteReview(reviewId);
            }
            response.sendRedirect(request.getContextPath() + "/viewReviews?msg=reviewDeleted");
            return;
        }

        doGet(request, response);
    }
}
