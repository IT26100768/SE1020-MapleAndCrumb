import com.mapleandcrumb.dao.PromotionDAO;
import com.mapleandcrumb.dao.impl.PromotionDAOImpl;
import com.mapleandcrumb.model.FixedAmountDiscount;
import com.mapleandcrumb.model.PercentageDiscount;
import com.mapleandcrumb.model.Promotion;

import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class PromotionDAOTest {

    @Test
    void testAddAndGetPromotion() {

        PromotionDAO dao = new PromotionDAOImpl();

        String code = "TEST_SAVE10";

        // Remove an old test record
        dao.deletePromotion(code);

        Promotion promotion = new PercentageDiscount(
                code,
                "Test 10 percent discount",
                LocalDate.now().plusDays(30),
                10
        );

        // CREATE
        dao.addPromotion(promotion);

        // READ
        Promotion found = dao.getPromotionByCode(code);

        assertNotNull(found);
        assertEquals(code, found.getPromoCode());
        assertEquals("Test 10 percent discount", found.getDescription());

        // Cleanup
        dao.deletePromotion(code);

        assertNull(dao.getPromotionByCode(code));
    }

    @Test
    void testGetAllPromotions() {

        PromotionDAO dao = new PromotionDAOImpl();

        String code = "TEST_SAVE200";

        dao.deletePromotion(code);

        Promotion promotion = new FixedAmountDiscount(
                code,
                "Test Rs. 200 discount",
                LocalDate.now().plusDays(30),
                200
        );

        dao.addPromotion(promotion);

        List<Promotion> promotions = dao.getAllPromotions();

        assertTrue(
                promotions.stream()
                        .anyMatch(p -> p.getPromoCode().equals(code))
        );

        // Cleanup
        dao.deletePromotion(code);
    }

    @Test
    void testGetAllActivePromotions() {

        PromotionDAO dao = new PromotionDAOImpl();

        String code = "TEST_ACTIVE10";

        dao.deletePromotion(code);

        Promotion promotion = new PercentageDiscount(
                code,
                "Test active promotion",
                LocalDate.now().plusDays(10),
                10
        );

        dao.addPromotion(promotion);

        List<Promotion> activePromotions = dao.getAllActivePromotions();

        assertTrue(
                activePromotions.stream()
                        .anyMatch(p -> p.getPromoCode().equals(code))
        );

        // Cleanup
        dao.deletePromotion(code);
    }

    @Test
    void testUpdatePromotion() {

        PromotionDAO dao = new PromotionDAOImpl();

        String code = "TEST_UPDATE10";

        dao.deletePromotion(code);

        Promotion original = new PercentageDiscount(
                code,
                "Original description",
                LocalDate.now().plusDays(30),
                10
        );

        dao.addPromotion(original);

        Promotion updated = new PercentageDiscount(
                code,
                "Updated description",
                LocalDate.now().plusDays(30),
                20
        );

        dao.updatePromotion(updated);

        Promotion found = dao.getPromotionByCode(code);

        assertNotNull(found);
        assertEquals("Updated description", found.getDescription());

        assertInstanceOf(PercentageDiscount.class, found);
        assertEquals(
                20.0,
                ((PercentageDiscount) found).getPercentage(),
                0.001
        );

        // Cleanup
        dao.deletePromotion(code);
    }

    @Test
    void testDeletePromotion() {

        PromotionDAO dao = new PromotionDAOImpl();

        String code = "TEST_DELETE10";

        dao.deletePromotion(code);

        Promotion promotion = new PercentageDiscount(
                code,
                "Promotion to delete",
                LocalDate.now().plusDays(30),
                10
        );

        dao.addPromotion(promotion);

        assertNotNull(dao.getPromotionByCode(code));

        dao.deletePromotion(code);

        assertNull(dao.getPromotionByCode(code));
    }
}