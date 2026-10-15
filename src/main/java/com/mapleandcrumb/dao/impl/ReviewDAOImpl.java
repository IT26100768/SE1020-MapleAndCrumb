package com.mapleandcrumb.dao.impl;

import com.mapleandcrumb.dao.ReviewDAO;
import com.mapleandcrumb.model.Review;
import com.mapleandcrumb.util.FileUtil;

import java.util.ArrayList;
import java.util.List;

/** File-based implementation of review management. */
public class ReviewDAOImpl implements ReviewDAO {
    private static final String FILE_NAME = "reviews.txt";

    @Override
    public void addReview(Review review) {
        if (review == null) throw new IllegalArgumentException("Review cannot be null");
        // Split on the first four commas only when reading, so comments may contain commas.
        String line = String.join(",", review.getReviewId(), review.getCustomerId(),
                review.getProductId(), String.valueOf(review.getRating()), clean(review.getComment()));
        FileUtil.appendToFile(FILE_NAME, line);
    }

    @Override
    public List<Review> getReviewsByProduct(String productId) {
        List<Review> result = new ArrayList<>();
        if (productId == null) return result;
        for (String line : FileUtil.readFromFile(FILE_NAME)) {
            Review review = parseLine(line);
            if (review != null && review.getProductId().equals(productId)) result.add(review);
        }
        return result;
    }

    @Override
    public List<Review> getAllReviews() {
        List<Review> result = new ArrayList<>();
        for (String line : FileUtil.readFromFile(FILE_NAME)) {
            Review review = parseLine(line);
            if (review != null) result.add(review);
        }
        return result;
    }

    @Override
    public void updateReview(Review review) {
        if (review == null) throw new IllegalArgumentException("Review cannot be null");
        List<String> updated = new ArrayList<>();
        boolean found = false;
        for (String line : FileUtil.readFromFile(FILE_NAME)) {
            String[] fields = line.split(",", 5);
            if (fields.length > 0 && fields[0].equals(review.getReviewId())) {
                if (!found) {
                    updated.add(toLine(review));
                    found = true;
                }
            } else if (!line.trim().isEmpty()) {
                updated.add(line);
            }
        }
        if (!found) updated.add(toLine(review));
        FileUtil.writeToFile(FILE_NAME, updated);
    }

    @Override
    public void deleteReview(String reviewId) {
        List<String> updated = new ArrayList<>();
        for (String line : FileUtil.readFromFile(FILE_NAME)) {
            String[] fields = line.split(",", 2);
            if (fields.length == 0 || !fields[0].equals(reviewId)) updated.add(line);
        }
        FileUtil.writeToFile(FILE_NAME, updated);
    }

    private String toLine(Review review) {
        return String.join(",", review.getReviewId(), review.getCustomerId(), review.getProductId(),
                String.valueOf(review.getRating()), clean(review.getComment()));
    }

    private Review parseLine(String line) {
        if (line == null || line.trim().isEmpty()) return null;
        String[] fields = line.split(",", 5);
        if (fields.length != 5) {
            System.err.println("Skipping invalid review record: " + line);
            return null;
        }
        try {
            return new Review(fields[0], fields[1], fields[2], Integer.parseInt(fields[3]), fields[4]);
        } catch (RuntimeException ex) {
            System.err.println("Skipping invalid review record: " + line);
            return null;
        }
    }

    private String clean(String value) {
        return value == null ? "" : value.replace("\r", " ").replace("\n", " ");
    }
}
