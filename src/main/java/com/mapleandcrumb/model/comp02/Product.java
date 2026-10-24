package com.mapleandcrumb.model.comp02;

public abstract class Product {
    private String productId;
    private String name;
    private String category;
    private double price;
    private int stockQuantity;

    public Product(String productId, String name, String category, double price, int stockQuantity) {
        this.productId = productId;
        this.name = name;
        this.category = category;
        this.price = price;
        this.stockQuantity = stockQuantity;
    }

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    public abstract String getDisplayDescription();

    /**
     * Unified factory method for creating concrete Product instances (StandardCake or StandardPastry)
     * based on the product category.
     */
    public static Product create(String id, String name, String category, double price, int stock,
                                 String flavor, Integer sizeInches, Boolean containsNuts) {
        if ("Cake".equalsIgnoreCase(category)) {
            String f = (flavor != null && !flavor.trim().isEmpty()) ? flavor.trim() : "Artisan Vanilla";
            int s = (sizeInches != null && sizeInches > 0) ? sizeInches : 8;
            return new StandardCake(id, name, price, stock, f, s);
        } else {
            boolean nuts = containsNuts != null && containsNuts;
            return new StandardPastry(id, name, category, price, stock, nuts);
        }
    }
}
