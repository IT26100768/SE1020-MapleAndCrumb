import com.mapleandcrumb.dao.ReviewDAO;
import com.mapleandcrumb.dao.impl.ReviewDAOImpl;
import com.mapleandcrumb.model.Review;

import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class ReviewDAOTest {

    @Test
    void testReviewCRUD() {

        ReviewDAO dao = new ReviewDAOImpl();

        String reviewId = "TEST_REVIEW_001";
        String productId = "TEST_PRODUCT_001";

        // Remove an old test record, if one exists
        dao.deleteReview(reviewId);

        // CREATE
        Review review = new Review(
                reviewId,
                "TEST_CUSTOMER_001",
                productId,
                5,
                "Excellent cake!"
        );

        dao.addReview(review);

        // READ
        List<Review> reviews = dao.getReviewsByProduct(productId);

        assertTrue(
                reviews.stream()
                        .anyMatch(r -> r.getReviewId().equals(reviewId))
        );

        // UPDATE
        Review updatedReview = new Review(
                reviewId,
                "TEST_CUSTOMER_001",
                productId,
                4,
                "Good cake!"
        );

        dao.updateReview(updatedReview);

        Review found = dao.getReviewsByProduct(productId)
                .stream()
                .filter(r -> r.getReviewId().equals(reviewId))
                .findFirst()
                .orElseThrow();

        assertEquals(4, found.getRating());
        assertEquals("Good cake!", found.getComment());

        // DELETE
        dao.deleteReview(reviewId);

        assertFalse(
                dao.getReviewsByProduct(productId)
                        .stream()
                        .anyMatch(r -> r.getReviewId().equals(reviewId))
        );
    }
}