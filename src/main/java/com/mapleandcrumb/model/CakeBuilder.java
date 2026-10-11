package com.mapleandcrumb.model;

public interface CakeBuilder {

    void selectFlavor(String flavor);

    void selectSize(int inches);

    void addCustomMessage(String message);

    double calculateBasePrice();
}
