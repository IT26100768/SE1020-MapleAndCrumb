package com.mapleandcrumb.dao;

import com.mapleandcrumb.model.Product;
import java.util.List;


public interface ProductDAO {


    void addProduct(Product product);


    Product getProductById(String productId);


    List<Product> searchByCategory(String category);


    List<Product> searchByName(String name);


    List<Product> getAllProducts();


    void updateProduct(Product product);


    void deleteProduct(String productId);
}

