package com.mapleandcrumb.dao.impl;
import com.mapleandcrumb.dao.ProductDAO;
import com.mapleandcrumb.model.Product;
import com.mapleandcrumb.model.StandardCake;
import com.mapleandcrumb.model.StandardPastry;
import com.mapleandcrumb.util.FileUtil;
import java.util.ArrayList;
import java.util.List;
public class ProductDAOImpl implements ProductDAO {
    private static final String FILE_NAME = "products.txt";

    @Override
    public void addProduct(Product product) {
        String line = "";

        if (product instanceof StandardCake) {
            StandardCake c = (StandardCake) product;
            line = c.getProductId() + "," + c.getName() + "," + c.getCategory() + ","
                    + c.getPrice() + "," + c.getStockQuantity() + ",CAKE," + c.getFlavor() + "," +
                    c.getSizeInches();
        } else if (product instanceof StandardPastry) {
            StandardPastry p = (StandardPastry) product;
            line = p.getProductId() + "," + p.getName() + "," + p.getCategory() + ","
                    + p.getPrice() + "," + p.getStockQuantity() + ",PASTRY," + p.isContainsNuts();
        }
        FileUtil.appendToFile(FILE_NAME, line);
    }


    @Override
    public Product getProductById(String productId) {
        List<String> lines = FileUtil.readFromFile(FILE_NAME);
        for (String line : lines) {
            String[] data = line.split(",");
            if (data.length > 0 && data[0].equals(productId)) {
                return mapLineToProduct(data);
            }
        }
        return null;
    }
    @Override
    public List<Product> searchByCategory(String category) {
        List<Product> results = new ArrayList<>();
        for (String line : FileUtil.readFromFile(FILE_NAME)) {
            String[] data = line.split(",");
            if (data.length > 2 && data[2].equalsIgnoreCase(category)) {

                results.add(mapLineToProduct(data));
            }
        }
        return results;
    }
    @Override
    public List<Product> searchByName(String name) {
        List<Product> results = new ArrayList<>();
        for (String line : FileUtil.readFromFile(FILE_NAME)) {
            String[] data = line.split(",");
            if (data.length > 1 && data[1].toLowerCase().contains(name.toLowerCase())) {
                results.add(mapLineToProduct(data));
            }
        }
        return results;
    }
    @Override
    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        for (String line : FileUtil.readFromFile(FILE_NAME)) {
            if (!line.trim().isEmpty()) products.add(mapLineToProduct(line.split(",")));
        }
        return products;
    }

    @Override
    public void updateProduct(Product product) {
        deleteProduct(product.getProductId());
        addProduct(product);
    }

    @Override
    public void deleteProduct(String productId) {
        List<String> lines = FileUtil.readFromFile(FILE_NAME);
        List<String> updatedLines = new ArrayList<>();
        for (String line : lines) {
            if (!line.startsWith(productId + ",")) updatedLines.add(line);
        }
        FileUtil.writeToFile(FILE_NAME, updatedLines);
    }

    private Product mapLineToProduct(String[] data) {
        if (data[5].equals("CAKE")) {
            return new StandardCake(data[0], data[1], Double.parseDouble(data[3]),
                    Integer.parseInt(data[4]), data[6], Integer.parseInt(data[7]));
        } else {
            return new StandardPastry(data[0], data[1], Double.parseDouble(data[3]),
                    Integer.parseInt(data[4]), Boolean.parseBoolean(data[6]));
        }
    }
}

