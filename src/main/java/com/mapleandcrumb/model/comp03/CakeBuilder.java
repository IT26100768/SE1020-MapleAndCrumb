package com.mapleandcrumb.model.comp03;

public interface CakeBuilder {

    void selectFlavor(String flavor);

    void selectSize(int inches);

    void addCustomMessage(String message);

    double calculateBasePrice();
}

