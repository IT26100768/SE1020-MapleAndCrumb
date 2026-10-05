CREATE DATABASE maple_and_crumb;
USE maple_and_crumb;

# Users Table
CREATE TABLE users
(
    user_id       INT AUTO_INCREMENT PRIMARY KEY,
    username      VARCHAR(50)                        NOT NULL UNIQUE,
    password_hash VARCHAR(255)                       NOT NULL,
    email         VARCHAR(100)                       NOT NULL UNIQUE,
    phone         VARCHAR(20),
    role          ENUM ('CUSTOMER', 'ADMIN','BAKER') NOT NULL,
    address       text,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

# Products Table
CREATE TABLE products
(
    product_id   INT AUTO_INCREMENT PRIMARY KEY,
    name         VARCHAR(100)                                 NOT NULL,
    description  TEXT,
    category     ENUM ('CAKE', 'PASTRY', 'BREAD', 'BEVERAGE') NOT NULL,
    base_price   DECIMAL(10, 2)                               NOT NULL,
    image_url    VARCHAR(255),
    is_available BOOLEAN DEFAULT TRUE
);

# Custom cake requests Table
CREATE TABLE custom_cake_requests
(
    request_id     INT AUTO_INCREMENT PRIMARY KEY,
    customer_id    INT         NOT NULL,
    flavor         VARCHAR(50) NOT NULL,
    size           VARCHAR(50) NOT NULL,
    design_details TEXT,
    quoted_price   DECIMAL(10, 2),
    status         ENUM ('PENDING', 'APPROVED', 'REJECTED','COMPLETED') DEFAULT 'PENDING',
    created_at     TIMESTAMP                                            DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES users (user_id) on DELETE CASCADE
);

# Orders Table
CREATE TABLE orders
(
    order_id        INT AUTO_INCREMENT PRIMARY KEY,
    customer_id     INT            NOT NULL,
    order_date      TIMESTAMP                                                      DEFAULT CURRENT_TIMESTAMP,
    total_amount    DECIMAL(10, 2) NOT NULL,
    status          ENUM ('PENDING', 'PROCESSING','READY','DELIVERED','CANCELLED') DEFAULT 'PENDING',
    delivery_date   DATE,
    is_custom_order BOOLEAN                                                        DEFAULT FALSE,
    FOREIGN KEY (customer_id) REFERENCES users (user_id) on DELETE CASCADE
);

# Order Items Table
CREATE TABLE order_items
(
    order_item_id     INT AUTO_INCREMENT PRIMARY KEY,
    order_id          INT            NOT NULL,
    product_id        INT,
    custom_request_id INT,
    quantity          INT            NOT NULL DEFAULT 1,
    subtotal          DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders (order_id) on DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products (product_id) on DELETE SET NULL,
    FOREIGN KEY (custom_request_id) REFERENCES Custom_Cake_Requests (request_id) on DELETE SET NULL
);

# Payments Table
CREATE TABLE payments
(
    payment_id       INT AUTO_INCREMENT PRIMARY KEY,
    order_id         INT                                                              NOT NULL,
    amount           DECIMAL(10, 2)                                                   NOT NULL,
    payment_method   ENUM ('CASH_ON_DELIVERY', 'SIMULATED_CARD', 'SIMULATED_EWallet') NOT NULL,
    status           ENUM ('SUCCESS', 'FAILED', 'PENDING') DEFAULT 'PENDING',
    transaction_date TIMESTAMP                             DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES Orders (order_id) on DELETE CASCADE
);
