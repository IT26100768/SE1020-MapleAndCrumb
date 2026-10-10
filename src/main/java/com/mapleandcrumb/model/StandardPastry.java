package com.mapleandcrumb.model;

public class StandardPastry extends Product {
    private boolean containsNuts;

    public StandardPastry(String productId, String name, double price, int stock, boolean
            containsNuts) {
        super(productId, name, "Pastry", price, stock);
        this.containsNuts = containsNuts;
    }

    public boolean isContainsNuts() {
        return containsNuts; }

    // POLYMORPHISM: Specific display method for Pastries (includes allergen warning)
    @Override
    public String getDisplayDescription() {
        String nutWarning = containsNuts ? " (Contains Nuts)" : " (Nut-Free)";
        return getName() + nutWarning + " - $" + getPrice();
    }
}
