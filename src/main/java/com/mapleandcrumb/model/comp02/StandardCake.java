package com.mapleandcrumb.model.comp02;

import java.util.Locale;

public class StandardCake extends Product {
    private String flavor;
    private int sizeInches;

    public StandardCake(String productId, String name, double price, int stock, String flavor, int sizeInches) {
        super(productId, name, "Cake", price, stock);
        this.flavor = flavor;
        this.sizeInches = sizeInches;
    }

    public String getFlavor() {
        return flavor;
    }

    public void setFlavor(String flavor) {
        this.flavor = flavor;
    }

    public int getSizeInches() {
        return sizeInches;
    }

    public void setSizeInches(int sizeInches) {
        this.sizeInches = sizeInches;
    }

    @Override
    public String getDisplayDescription() {
        return getSizeInches() + "-inch " + getFlavor() + " Cake - Rs. " + String.format(Locale.US, "%.2f", getPrice());
    }
}
