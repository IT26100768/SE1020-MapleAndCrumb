package com.mapleandcrumb.dao.comp06;

import com.mapleandcrumb.model.comp06.Promotion;

import java.util.List;

public interface PromotionDAO {

    void addPromotionByCode(String promoCode);

    List<Promotion> getAllActivePromotions();

    List<Promotion> getAllPromotions();

    void updatePromotion(Promotion promotion);

    void deletePromotion(String promoCode);

    void addPromotion(Promotion promotion);

    Promotion getPromotionByCode(String promoCode);
}
