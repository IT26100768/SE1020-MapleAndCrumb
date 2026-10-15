import com.mapleandcrumb.model.FixedAmountDiscount;
import com.mapleandcrumb.model.PercentageDiscount;

import org.junit.jupiter.api.Test;

import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class PromotionTest {

    @Test
    void testPercentageDiscount() {

        LocalDate expiryDate = LocalDate.now().plusDays(30);

        PercentageDiscount discount = new PercentageDiscount(
                "SAVE10",
                "10 percent discount",
                expiryDate,
                10
        );

        double result = discount.applyDiscount(1000);

        assertEquals(900.0, result, 0.001);
    }

    @Test
    void testFixedAmountDiscount() {

        LocalDate expiryDate = LocalDate.now().plusDays(30);

        FixedAmountDiscount discount = new FixedAmountDiscount(
                "SAVE200",
                "Rs. 200 discount",
                expiryDate,
                200
        );

        double result = discount.applyDiscount(1000);

        assertEquals(800.0, result, 0.001);
    }

    @Test
    void testPercentageDiscountWithZeroPrice() {

        LocalDate expiryDate = LocalDate.now().plusDays(30);

        PercentageDiscount discount = new PercentageDiscount(
                "SAVE10",
                "10 percent discount",
                expiryDate,
                10
        );

        assertEquals(0.0, discount.applyDiscount(0), 0.001);
    }
}