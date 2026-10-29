package com.mapleandcrumb.model.comp06;

import java.time.LocalDateTime;

public class Review {
    private String reviewId;
    private String customerId;
    private String customerName;
    private String productId;
    private String productName;
    private int rating = 5;
    private String comment;
    private LocalDateTime reviewDate;

    public Review() {
        this.reviewDate = LocalDateTime.now();
    }

    public Review(String reviewId, String customerId, String productId, int rating, String comment) {
        this.reviewId = reviewId;
        this.customerId = customerId;
        this.productId = productId;
        setRating(rating);
        this.comment = comment;
        this.reviewDate = LocalDateTime.now();
    }

    public Review(String reviewId, String customerId, String customerName, String productId, String productName, int rating, String comment, LocalDateTime reviewDate) {
        this.reviewId = reviewId;
        this.customerId = customerId;
        this.customerName = customerName;
        this.productId = productId;
        this.productName = productName;
        setRating(rating);
        this.comment = comment;
        this.reviewDate = reviewDate != null ? reviewDate : LocalDateTime.now();
    }

    public void setRating(int rating) {
        if (rating >= 1 && rating <= 5) {
            this.rating = rating;
        } else {
            throw new IllegalArgumentException("Rating must be between 1 and 5");
        }
    }

    public String getReviewId() {
        return reviewId;
    }

    public void setReviewId(String reviewId) {
        this.reviewId = reviewId;
    }

    public String getCustomerId() {
        return customerId;
    }

    public void setCustomerId(String customerId) {
        this.customerId = customerId;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public int getRating() {
        return rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public LocalDateTime getReviewDate() {
        return reviewDate;
    }

    public void setReviewDate(LocalDateTime reviewDate) {
        this.reviewDate = reviewDate;
    }
}
