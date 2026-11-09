-- ============================================================================
-- Maple & Crumb Bakery Database Schema & Initial Data
-- ============================================================================

CREATE DATABASE IF NOT EXISTS maple_and_crumb
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE maple_and_crumb;
ALTER DATABASE maple_and_crumb
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

-- Disable foreign key checks for clean tear-down and re-creation
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS kitchen_tasks;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS custom_cake_requests;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS promotions;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS users;

SET FOREIGN_KEY_CHECKS = 1;

-- ----------------------------------------------------------------------------
-- 1. Users Table
-- Supports Polymorphic User Hierarchy: Customer, Staff, and Admin
-- ----------------------------------------------------------------------------
CREATE TABLE users
(
    user_id        INT AUTO_INCREMENT PRIMARY KEY,
    user_code      VARCHAR(50) UNIQUE,
    username       VARCHAR(50) NOT NULL UNIQUE,
    password_hash  VARCHAR(255) NOT NULL,
    email          VARCHAR(100) NOT NULL UNIQUE,
    phone          VARCHAR(20),
    role           ENUM ('CUSTOMER', 'ADMIN', 'STAFF', 'BAKER') NOT NULL DEFAULT 'CUSTOMER',
    address        TEXT,
    staff_id       VARCHAR(50) UNIQUE,
    monthly_salary DECIMAL(10, 2),
    admin_level    VARCHAR(50),
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- 2. Products Table
-- Supports StandardCake (flavor, size_inches) & StandardPastry (contains_nuts)
-- ----------------------------------------------------------------------------
CREATE TABLE products
(
    product_id     INT AUTO_INCREMENT PRIMARY KEY,
    product_code   VARCHAR(50) UNIQUE,
    name           VARCHAR(100) NOT NULL,
    description    TEXT,
    category       VARCHAR(50) NOT NULL,
    base_price     DECIMAL(10, 2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    flavor         VARCHAR(50),
    size_inches    INT,
    contains_nuts  BOOLEAN DEFAULT FALSE,
    image_url      VARCHAR(255),
    is_available   BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- 3. Custom Cake Requests Table
-- Corresponds to CustomCakeOrder / CakeBuilder
-- ----------------------------------------------------------------------------
CREATE TABLE custom_cake_requests
(
    request_id     INT AUTO_INCREMENT PRIMARY KEY,
    booking_code   VARCHAR(50) UNIQUE,
    customer_id    INT NOT NULL,
    flavor         VARCHAR(50) NOT NULL,
    size           VARCHAR(50) NOT NULL,
    design_details TEXT,
    quoted_price   DECIMAL(10, 2),
    pickup_date    DATE,
    status         VARCHAR(30) DEFAULT 'Pending',
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES users (user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- 4. Orders Table
-- Supports DeliveryOrder (deliveryAddress) and PickupOrder
-- ----------------------------------------------------------------------------
CREATE TABLE orders
(
    order_id         INT AUTO_INCREMENT PRIMARY KEY,
    order_code       VARCHAR(50) UNIQUE,
    customer_id      INT NOT NULL,
    order_date       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount     DECIMAL(10, 2) NOT NULL,
    status           VARCHAR(30) DEFAULT 'Pending',
    order_type       VARCHAR(20) DEFAULT 'Pickup',
    delivery_address VARCHAR(255),
    delivery_date    DATE,
    is_custom_order  BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (customer_id) REFERENCES users (user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- 5. Order Items Table
-- Links orders with catalog products or custom requests
-- ----------------------------------------------------------------------------
CREATE TABLE order_items
(
    order_item_id     INT AUTO_INCREMENT PRIMARY KEY,
    order_id          INT NOT NULL,
    product_id        INT,
    custom_request_id INT,
    product_name      VARCHAR(100),
    quantity          INT NOT NULL DEFAULT 1,
    unit_price        DECIMAL(10, 2) NOT NULL,
    subtotal          DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders (order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products (product_id) ON DELETE SET NULL,
    FOREIGN KEY (custom_request_id) REFERENCES custom_cake_requests (request_id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- 6. Payments Table
-- Payment transactions associated with Orders
-- ----------------------------------------------------------------------------
CREATE TABLE payments
(
    payment_id       INT AUTO_INCREMENT PRIMARY KEY,
    order_id         INT NOT NULL,
    amount           DECIMAL(10, 2) NOT NULL,
    payment_method   VARCHAR(50) NOT NULL,
    status           VARCHAR(30) DEFAULT 'PENDING',
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders (order_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- 7. Promotions Table
-- Corresponds to Promotion / PercentageDiscount / FixedAmountDiscount
-- ----------------------------------------------------------------------------
CREATE TABLE promotions
(
    promo_code     VARCHAR(50) PRIMARY KEY,
    description    VARCHAR(255),
    expiry_date    DATE NOT NULL,
    discount_type  ENUM ('PERCENTAGE', 'FIXED') NOT NULL,
    discount_value DECIMAL(10, 2) NOT NULL,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- 8. Reviews Table
-- Corresponds to Review submitted by customers for catalog products
-- ----------------------------------------------------------------------------
CREATE TABLE reviews
(
    review_id    INT AUTO_INCREMENT PRIMARY KEY,
    review_code  VARCHAR(50) UNIQUE,
    customer_id  INT,
    product_id   INT,
    rating       INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment      TEXT,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES users (user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products (product_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- 9. Kitchen Tasks Table
-- Component 5: Production and Kitchen Operations Queue
-- ----------------------------------------------------------------------------
CREATE TABLE kitchen_tasks
(
    task_id           INT AUTO_INCREMENT PRIMARY KEY,
    task_type         ENUM ('ORDER', 'CUSTOM_CAKE') NOT NULL,
    order_id          INT NULL,
    custom_request_id INT NULL,
    assigned_baker_id INT NULL,
    prep_stage        ENUM ('PENDING', 'IN_PREPARATION', 'READY_FOR_PICKUP', 'COMPLETED', 'CANCELLED') NOT NULL DEFAULT 'PENDING',
    due_datetime      DATETIME NOT NULL,
    time_slot         VARCHAR(60) NULL,
    priority          ENUM ('NORMAL', 'HIGH', 'URGENT') NOT NULL DEFAULT 'NORMAL',
    kitchen_notes     TEXT NULL,
    created_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    started_at        TIMESTAMP NULL,
    completed_at      TIMESTAMP NULL,
    INDEX idx_kt_due (due_datetime, prep_stage),
    INDEX idx_kt_stage (prep_stage, due_datetime),
    INDEX idx_kt_baker (assigned_baker_id, prep_stage),
    FOREIGN KEY (order_id) REFERENCES orders (order_id) ON DELETE CASCADE,
    FOREIGN KEY (custom_request_id) REFERENCES custom_cake_requests (request_id) ON DELETE CASCADE,
    FOREIGN KEY (assigned_baker_id) REFERENCES users (user_id) ON DELETE SET NULL,
    CONSTRAINT chk_kt_source CHECK (
        (task_type = 'ORDER' AND order_id IS NOT NULL AND custom_request_id IS NULL) OR
        (task_type = 'CUSTOM_CAKE' AND custom_request_id IS NOT NULL AND order_id IS NULL)
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- SEED DATA (Migrated from data/*.txt with pre-hashed SHA-256 passwords)
-- ============================================================================

-- Users (Raw passwords):
-- root@maple.com           -> root@123
-- chef@maple.com           -> BakingSecrets123
-- admin@maple.com          -> AdminPass123
-- test_cust@maple.com      -> Pass1234
-- sahanroshitha66@gmail.com -> 123456
INSERT INTO users (user_id, user_code, username, password_hash, email, phone, role, address, staff_id, monthly_salary, admin_level) VALUES
(1, 'U_ROOT', 'SuperAdmin', 'root@123', 'root@maple.com', '000', 'ADMIN', NULL, 'STF_ROOT', 8000.00, 'Super'),
(2, 'UE1544', 'Chef Baker', 'BakingSecrets123', 'chef@maple.com', '5551234', 'STAFF', NULL, 'STF5C4F', 3500.00, NULL),
(3, 'U_ADMIN01', 'Bakery Admin', 'AdminPass123', 'admin@maple.com', '+1555123456', 'ADMIN', NULL, 'STF_ADM1', 5000.00, 'Super'),
(4, 'U_TEST_01', 'Test Customer', 'Pass1234', 'test_cust@maple.com', '1234567890', 'CUSTOMER', '123 Test St', NULL, NULL, NULL),
(5, 'UF06CE', 'Sahan', '123456', 'sahanroshitha66@gmail.com', '+94781138678', 'CUSTOMER', '13/B Seethagama', NULL, NULL, NULL);

-- Products:
INSERT INTO products (product_id, product_code, name, category, base_price, stock_quantity, flavor, size_inches, contains_nuts, is_available) VALUES
(1, 'P_CHK_01', 'Artisan Brioche', 'Pastry', 5.00, 16, NULL, NULL, FALSE, TRUE),
(2, 'P_CHK_02', 'Belgian Chocolate Croissant', 'Pastry', 4.50, 20, NULL, NULL, FALSE, TRUE),
(3, 'P_CHK_03', 'Madagascar Vanilla Sponge Cake', 'Cake', 32.00, 8, 'Bourbon Vanilla', 6, FALSE, TRUE),
(4, 'P_BRD_01', 'Rustic Country Sourdough', 'Bread', 6.50, 14, NULL, NULL, FALSE, TRUE),
(5, 'P_BRD_02', 'Artisan French Baguette', 'Bread', 4.00, 18, NULL, NULL, FALSE, TRUE),
(6, 'P_BRD_03', 'Walnut Cranberry Loaf', 'Bread', 7.50, 6, NULL, NULL, TRUE, TRUE);

-- Promotions:
INSERT INTO promotions (promo_code, description, expiry_date, discount_type, discount_value) VALUES
('AUTUMN15', '15% off all autumn specials', '2026-12-15', 'PERCENTAGE', 15.00),
('WELCOME5', 'Rs. 5.00 off welcome voucher', '2026-12-31', 'FIXED', 5.00);

-- Custom Cake Requests:
INSERT INTO custom_cake_requests (request_id, booking_code, customer_id, flavor, size, design_details, quoted_price, pickup_date, status) VALUES
(1, 'BKD65FD', 4, 'Belgian Chocolate Fudge', '10', 'Happy Anniversary!', 150.00, '2026-10-18', 'Pending'),
(2, 'BK_CANCEL_TEST', 4, 'Vanilla', '6', 'Birthday Celebration', 90.00, '2026-10-17', 'Cancelled');

-- Orders:
INSERT INTO orders (order_id, order_code, customer_id, total_amount, status, order_type, delivery_address, delivery_date) VALUES
(1, 'ORD54967', 4, 15.00, 'Pending', 'Delivery', '123 Test St', '2026-10-17'),
(2, 'ORD_CANCEL_01', 4, 0.00, 'Cancelled', 'Pickup', 'N/A', '2026-10-17');

-- Order Items:
INSERT INTO order_items (order_item_id, order_id, product_id, product_name, quantity, unit_price, subtotal) VALUES
(1, 1, 1, 'Artisan Brioche', 2, 5.00, 10.00);

-- Reviews:
INSERT INTO reviews (review_id, review_code, customer_id, product_id, rating, comment) VALUES
(1, 'REV3F7AF', 4, 1, 5, 'Absolutely delightful texture and aroma!'),
(2, 'REV1D3FF', 4, 1, 5, 'The flakiest brioche in the city!');

-- Kitchen Tasks (Production Queue Seed):
INSERT INTO kitchen_tasks (task_id, task_type, order_id, custom_request_id, assigned_baker_id, prep_stage, due_datetime, time_slot, priority, kitchen_notes) VALUES
(1, 'ORDER', 1, NULL, 2, 'IN_PREPARATION', DATE_ADD(CURRENT_DATE(), INTERVAL 10 HOUR), 'Morning (9:00 AM - 12:00 PM)', 'NORMAL', 'Fresh morning delivery dispatch. Pack in insulated box.'),
(2, 'CUSTOM_CAKE', NULL, 1, 2, 'IN_PREPARATION', DATE_ADD(CURRENT_DATE(), INTERVAL 14 HOUR), 'Afternoon (1:00 PM - 4:00 PM)', 'HIGH', 'Belgian Chocolate Anniversary Cake - Royal Icing: Happy Anniversary!');
