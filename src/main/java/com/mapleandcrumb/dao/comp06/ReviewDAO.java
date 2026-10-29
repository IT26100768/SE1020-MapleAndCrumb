package com.mapleandcrumb.dao.comp06;

import com.mapleandcrumb.model.comp06.Review;

import java.util.List;

public interface ReviewDAO {

    void addReview(Review review);

    List<Review> getReviewsByProduct(String productId);

    List<Review> getAllReviews();

    void updateReview(Review review);

    void deleteReview(String reviewId);
}

