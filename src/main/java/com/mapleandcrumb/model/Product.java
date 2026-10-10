package com.mapleandcrumb.model;

public class Product {
    private String productId;
    private String name;
    private String category;
    private double price;
    private int stockQuantity;

    public Product(String productId, String name, String category, double price, int
            stockQuantity) {
        this.productId = productId;
        this.name = name;
        this.category = category;
        this.price = price;
        this.stockQuantity = stockQuantity;
    }


    public String getProductId() {
        return productId; }
    public String getName() {
        return name; }
    public void setName(String name) {
        this.name = name; }
    public String getCategory() {
        return category; }
    public double getPrice() {
        return price; }
    public void setPrice(double price) {
        this.price = price; }
    public int getStockQuantity() {
        return stockQuantity; }
    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity; }


    differently.
    public abstract String getDisplayDescription();
}

