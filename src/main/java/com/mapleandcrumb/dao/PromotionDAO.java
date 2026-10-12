package com.mapleandcrumb.dao;

import com.mapleandcrumb.model.Promotion;

import java.util.List;

public interface PromotionDAO {

    void addPromotionByCode(String promoCode);

    List<Promotion> getAllActivePromotions();

    List<Promotion> getAllPromotions();

    void updatePromotion(Promotion promotion);

    void deletePromotion(String promoCode);
}
