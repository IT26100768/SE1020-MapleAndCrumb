CREATE DATABASE IF NOT EXISTS maple_and_crumb
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE maple_and_crumb;
ALTER DATABASE maple_and_crumb
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

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

-- 1. Users Table
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

-- 2. Products Table
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

-- 3. Custom Cake Requests Table
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

-- 4. Orders Table
-- Supports DeliveryOrder (deliveryAddress) and PickupOrder
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

-- 5. Order Items Table
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

-- 6. Payments Table
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

-- 7. Promotions Table
CREATE TABLE promotions
(
    promo_code     VARCHAR(50) PRIMARY KEY,
    description    VARCHAR(255),
    expiry_date    DATE NOT NULL,
    discount_type  ENUM ('PERCENTAGE', 'FIXED') NOT NULL,
    discount_value DECIMAL(10, 2) NOT NULL,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 8. Reviews Table
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

-- 9. Kitchen Tasks Table
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

-- Initial Data
INSERT INTO users (user_id, user_code, username, password_hash, email, phone, role, address, staff_id, monthly_salary, admin_level) VALUES
(1, 'U_ROOT', 'SuperAdmin', 'root@123', 'root@maple.com', '000', 'ADMIN', NULL, 'STF_ROOT', 8000.00, 'Super'),
(2, 'UE1544', 'Chef Baker', 'BakingSecrets123', 'chef@maple.com', '5551234', 'STAFF', NULL, 'STF5C4F', 3500.00, NULL),
(3, 'U_CUST01', 'Sahan Roshitha', '123456', 'sahanroshitha66@gmail.com', '+94781138678', 'CUSTOMER', '13/B Seethagama', NULL, NULL, NULL);

INSERT INTO products (product_id, product_code, name, category, base_price, stock_quantity, flavor, size_inches, contains_nuts, is_available) VALUES
(1, 'P_CHK_01', 'Belgian Chocolate Croissant', 'Pastry', 450.00, 20, NULL, NULL, FALSE, TRUE),
(2, 'P_CHK_02', 'Madagascar Vanilla Sponge Cake', 'Cake', 3200.00, 10, 'Bourbon Vanilla', 6, FALSE, TRUE);

INSERT INTO promotions (promo_code, description, expiry_date, discount_type, discount_value) VALUES
('WELCOME200', '200 LKR off welcome voucher', '2026-12-31', 'FIXED', 200.00);

INSERT INTO reviews (review_id, review_code, customer_id, product_id, rating, comment) VALUES
(1, 'REV001', 3, 1, 5, 'Flaky, buttery, and rich chocolate filling! Highly recommended.');
