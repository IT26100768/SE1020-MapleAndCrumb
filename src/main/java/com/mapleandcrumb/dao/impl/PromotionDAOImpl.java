package com.mapleandcrumb.dao.impl;

import com.mapleandcrumb.dao.PromotionDAO;
import com.mapleandcrumb.model.FixedAmountDiscount;
import com.mapleandcrumb.model.PercentageDiscount;
import com.mapleandcrumb.model.Promotion;
import com.mapleandcrumb.util.FileUtil;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/** File-based implementation of promotion management. */
public class PromotionDAOImpl implements PromotionDAO {
    private static final String FILE_NAME = "promotions.txt";

    @Override
    public void addPromotion(Promotion promotion) {
        if (promotion == null) throw new IllegalArgumentException("Promotion cannot be null");
        // Format: promoCode,description,expiryDate,type,value
        FileUtil.appendToFile(FILE_NAME, toLine(promotion));
    }

    @Override
    public Promotion getPromotionByCode(String promoCode) {
        if (promoCode == null) return null;
        for (String line : FileUtil.readFromFile(FILE_NAME)) {
            Promotion promotion = parseLine(line);
            if (promotion != null && promotion.getPromoCode().equalsIgnoreCase(promoCode.trim())) {
                return promotion;
            }
        }
        return null;
    }

    @Override
    public List<Promotion> getAllActivePromotions() {
        List<Promotion> result = new ArrayList<>();
        LocalDate today = LocalDate.now();
        for (Promotion promotion : getAllPromotions()) {
            if (!promotion.getExpiryDate().isBefore(today)) result.add(promotion);
        }
        return result;
    }

    @Override
    public List<Promotion> getAllPromotions() {
        List<Promotion> result = new ArrayList<>();
        for (String line : FileUtil.readFromFile(FILE_NAME)) {
            Promotion promotion = parseLine(line);
            if (promotion != null) result.add(promotion);
        }
        return result;
    }

    @Override
    public void updatePromotion(Promotion promotion) {
        if (promotion == null) throw new IllegalArgumentException("Promotion cannot be null");
        List<String> updated = new ArrayList<>();
        boolean found = false;
        for (String line : FileUtil.readFromFile(FILE_NAME)) {
            String[] fields = line.split(",", 2);
            if (fields.length > 0 && fields[0].equalsIgnoreCase(promotion.getPromoCode())) {
                if (!found) {
                    updated.add(toLine(promotion));
                    found = true;
                }
            } else if (!line.trim().isEmpty()) {
                updated.add(line);
            }
        }
        if (!found) updated.add(toLine(promotion));
        FileUtil.writeToFile(FILE_NAME, updated);
    }

    @Override
    public void deletePromotion(String promoCode) {
        List<String> updated = new ArrayList<>();
        for (String line : FileUtil.readFromFile(FILE_NAME)) {
            String[] fields = line.split(",", 2);
            if (fields.length == 0 || !fields[0].equalsIgnoreCase(promoCode)) updated.add(line);
        }
        FileUtil.writeToFile(FILE_NAME, updated);
    }

    private String toLine(Promotion promotion) {
        String type;
        String value;
        if (promotion instanceof PercentageDiscount) {
            type = "Percentage";
            value = String.valueOf(((PercentageDiscount) promotion).getPercentage());
        } else if (promotion instanceof FixedAmountDiscount) {
            type = "Fixed";
            value = String.valueOf(((FixedAmountDiscount) promotion).getFixedAmount());
        } else {
            throw new IllegalArgumentException("Unsupported promotion type: " + promotion.getClass().getName());
        }
        // Commas are replaced in descriptions because commas separate the file fields.
        String description = promotion.getDescription().replace(',', ';').replace('\n', ' ').replace('\r', ' ');
        return String.join(",", promotion.getPromoCode(), description,
                promotion.getExpiryDate().toString(), type, value);
    }

    private Promotion parseLine(String line) {
        if (line == null || line.trim().isEmpty()) return null;
        String[] fields = line.split(",", 5);
        if (fields.length != 5) {
            System.err.println("Skipping invalid promotion record: " + line);
            return null;
        }
        try {
            LocalDate expiryDate = LocalDate.parse(fields[2]);
            double value = Double.parseDouble(fields[4]);
            if (fields[3].equalsIgnoreCase("Percentage")) {
                return new PercentageDiscount(fields[0], fields[1], expiryDate, value);
            }
            if (fields[3].equalsIgnoreCase("Fixed")) {
                return new FixedAmountDiscount(fields[0], fields[1], expiryDate, value);
            }
            System.err.println("Skipping unknown promotion type: " + fields[3]);
            return null;
        } catch (RuntimeException ex) {
            System.err.println("Skipping invalid promotion record: " + line);
            return null;
        }
    }
}
