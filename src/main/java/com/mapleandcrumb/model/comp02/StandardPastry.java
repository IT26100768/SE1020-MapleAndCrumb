package com.mapleandcrumb.model.comp02;

import java.util.Locale;

public class StandardPastry extends Product {
    private boolean containsNuts;

    public StandardPastry(String productId, String name, String category, double price, int stock, boolean containsNuts) {
        super(productId, name, (category != null && !category.trim().isEmpty()) ? category : "Pastry", price, stock);
        this.containsNuts = containsNuts;
    }

    public StandardPastry(String productId, String name, double price, int stock, boolean containsNuts) {
        this(productId, name, "Pastry", price, stock, containsNuts);
    }

    public boolean isContainsNuts() {
        return containsNuts;
    }

    public void setContainsNuts(boolean containsNuts) {
        this.containsNuts = containsNuts;
    }

    @Override
    public String getDisplayDescription() {
        String nutWarning = containsNuts ? " (Contains Nuts)" : " (Nut-Free)";
        return getName() + nutWarning + " - Rs. " + String.format(Locale.US, "%.2f", getPrice());
    }
}
