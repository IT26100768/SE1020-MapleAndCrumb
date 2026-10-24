package com.mapleandcrumb.dao.impl.comp02;

import com.mapleandcrumb.dao.comp02.ProductDAO;
import com.mapleandcrumb.model.comp02.Product;
import com.mapleandcrumb.model.comp02.StandardCake;
import com.mapleandcrumb.model.comp02.StandardPastry;
import com.mapleandcrumb.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.List;

public class ProductDAOImpl implements ProductDAO {

    @Override
    public void addProduct(Product product) {
        if (product == null) return;

        String flavor = (product instanceof StandardCake) ? ((StandardCake) product).getFlavor() : null;
        Integer sizeInches = (product instanceof StandardCake) ? ((StandardCake) product).getSizeInches() : null;
        boolean containsNuts = (product instanceof StandardPastry) && ((StandardPastry) product).isContainsNuts();

        String sql = "INSERT INTO products (product_code, name, category, base_price, stock_quantity, flavor, size_inches, contains_nuts, is_available) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, TRUE)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, product.getProductId());
            ps.setString(2, product.getName());
            ps.setString(3, product.getCategory());
            ps.setDouble(4, product.getPrice());
            ps.setInt(5, product.getStockQuantity());
            ps.setString(6, flavor);
            if (sizeInches != null) {
                ps.setInt(7, sizeInches);
            } else {
                ps.setNull(7, Types.INTEGER);
            }
            ps.setBoolean(8, containsNuts);
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next() && (product.getProductId() == null || product.getProductId().isEmpty())) {
                    product.setProductId(String.valueOf(rs.getInt(1)));
                }
            }
        } catch (SQLException e) {
            System.err.println("ProductDAOImpl: Error adding product: " + e.getMessage());
        }
    }

    @Override
    public Product getProductById(String productId) {
        if (productId == null || productId.trim().isEmpty()) return null;
        Integer numId = parseInteger(productId);
        String sql = (numId != null)
                ? "SELECT * FROM products WHERE product_id = ? OR product_code = ?"
                : "SELECT * FROM products WHERE product_code = ?";
        return (numId != null)
                ? DBUtil.querySingle(sql, this::mapRowToProduct, numId, productId.trim())
                : DBUtil.querySingle(sql, this::mapRowToProduct, productId.trim());
    }

    @Override
    public List<Product> searchByCategory(String category) {
        if (category == null || category.trim().isEmpty() || "ALL".equalsIgnoreCase(category.trim())) {
            return getAllProducts();
        }
        return DBUtil.queryList("SELECT * FROM products WHERE LOWER(category) = LOWER(?) ORDER BY product_id ASC",
                this::mapRowToProduct, category.trim());
    }
    @Override
    public List<Product> searchByName(String name) {
        if (name == null || name.trim().isEmpty()) {
            return getAllProducts();
        }
        return DBUtil.queryList("SELECT * FROM products WHERE LOWER(name) LIKE ? ORDER BY product_id ASC",
                this::mapRowToProduct, "%" + name.trim().toLowerCase() + "%");
    }

    @Override
    public List<Product> getAllProducts() {
        return DBUtil.queryList("SELECT * FROM products ORDER BY product_id ASC", this::mapRowToProduct);
    }

    @Override
    public int getProductCount() {
        return DBUtil.queryCount("SELECT COUNT(*) FROM products");
    }

    @Override
    public void updateProduct(Product product) {
        if (product == null) return;
        String flavor = (product instanceof StandardCake) ? ((StandardCake) product).getFlavor() : null;
        Integer sizeInches = (product instanceof StandardCake) ? ((StandardCake) product).getSizeInches() : null;
        boolean containsNuts = (product instanceof StandardPastry) && ((StandardPastry) product).isContainsNuts();

        try (Connection conn = DBUtil.getConnection()) {
            Integer internalId = DBUtil.findProductIdByCodeOrId(conn, product.getProductId());
            String sql = "UPDATE products SET name = ?, category = ?, base_price = ?, stock_quantity = ?, flavor = ?, size_inches = ?, contains_nuts = ? "
                    + "WHERE product_id = ? OR product_code = ?";
            DBUtil.executeUpdate(sql, product.getName(), product.getCategory(), product.getPrice(),
                    product.getStockQuantity(), flavor, sizeInches, containsNuts,
                    internalId != null ? internalId : -1, product.getProductId());
        } catch (SQLException e) {
            System.err.println("ProductDAOImpl: Error updating product: " + e.getMessage());
        }
    }

    @Override
    public void deleteProduct(String productId) {
        if (productId == null || productId.trim().isEmpty()) return;
        Integer numId = parseInteger(productId);
        String sql = (numId != null)
                ? "DELETE FROM products WHERE product_id = ? OR product_code = ?"
                : "DELETE FROM products WHERE product_code = ?";
        if (numId != null) {
            DBUtil.executeUpdate(sql, numId, productId.trim());
        } else {
            DBUtil.executeUpdate(sql, productId.trim());
        }
    }

    private Integer parseInteger(String val) {
        try {
            return Integer.parseInt(val.trim());
        } catch (Exception e) {
            return null;
        }
    }
    mapRowToProduct(ResultSet rs) throws SQLException {
        int prodIdInt = rs.getInt("product_id");
        String prodCode = rs.getString("product_code");
        String idToUse = (prodCode != null && !prodCode.trim().isEmpty()) ? prodCode : String.valueOf(prodIdInt);

        String name = rs.getString("name");
        String category = rs.getString("category");
        if (category == null || category.trim().isEmpty()) {
            category = "Pastry";
        }
        double price = rs.getDouble("base_price");
        int stock = rs.getInt("stock_quantity");
        String flavor = rs.getString("flavor");
        int sizeInches = rs.getInt("size_inches");
        boolean containsNuts = rs.getBoolean("contains_nuts");

        return Product.create(idToUse, name, category, price, stock, flavor, sizeInches, containsNuts);
    }
}
