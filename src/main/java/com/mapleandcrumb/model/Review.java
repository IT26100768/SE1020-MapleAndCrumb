package com.mapleandcrumb.model;

import java.time.LocalDateTime;

public class Review {
    private String reviewId;
    private String customerId;
    private String productId;
    private int rating;
    private String comment;
    private LocalDateTime reviewDate;

    public Review(String reviewId, String customerId, String productId, int rating, String comment) {
        this.reviewId = reviewId;
        this.customerId = customerId;
        this.productId = productId;
        setRating(rating);
        this.comment = comment;
        this.reviewDate = LocalDateTime.now();
    }

    public void setRating(int rating) {
        if (rating >= 1 && rating <= 5) {
            this.rating = rating;
        } else {
            try {
                throw new IllegalAccessException("Rating must be between 1 and 5");
            } catch (IllegalAccessException e) {
                throw new RuntimeException(e);
            }
        }
    }

    public String getReviewId() {
        return reviewId;
    }

    public String getCustomerId() {
        return customerId;
    }

    public String getProductId() {
        return productId;
    }

    public int getRating() {
        return rating;
    }

    public String getComment() {
        return comment;
    }
}
