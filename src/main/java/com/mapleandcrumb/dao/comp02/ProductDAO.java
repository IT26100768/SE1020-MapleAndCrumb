package com.mapleandcrumb.dao.comp02;

import com.mapleandcrumb.model.comp02.Product;
import java.util.List;

public interface ProductDAO {

    void addProduct(Product product);

    Product getProductById(String productId);

    List<Product> searchByCategory(String category);

    List<Product> searchByName(String name);

    List<Product> getAllProducts();

    int getProductCount();

    void updateProduct(Product product);

    void deleteProduct(String productId);

    int getLowStockCount(int threshold);

    List<Product> getLowStockProducts(int limit);
}
