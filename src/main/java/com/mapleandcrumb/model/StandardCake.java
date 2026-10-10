package com.mapleandcrumb.model;

public class StandardCake extends Product {
    private String flavor;
    private int sizeInches;

    public StandardCake(String productId, String name, double price, int stock, String
            flavor, int sizeInches) {
        super(productId, name, "Cake", price, stock);
        this.flavor = flavor;
        this.sizeInches = sizeInches;
    }

    public String getFlavor() {
        return flavor; }
    public int getSizeInches() {
        return sizeInches; }

    // POLYMORPHISM: Specific display method for Cakes
    @Override
    public String getDisplayDescription() {
        return getSizeInches() + "-inch " + getFlavor() + " Cake - $" + getPrice();
    }
}
