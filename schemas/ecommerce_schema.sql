-- ============================================
-- E-Commerce Database Schema
-- Optimized for PostgreSQL
-- Author: Swarna Parida | 15+ Years database Experience
-- ============================================

CREATE TABLE customers (
    customer_id   SERIAL PRIMARY KEY,
    email         VARCHAR(255) NOT NULL UNIQUE,
    full_name     VARCHAR(100) NOT NULL,
    created_at    TIMESTAMP DEFAULT NOW(),
    is_active     BOOLEAN DEFAULT TRUE
);

CREATE TABLE products (
    product_id    SERIAL PRIMARY KEY,
    sku           VARCHAR(50) NOT NULL UNIQUE,
    product_name  VARCHAR(200) NOT NULL,
    price         NUMERIC(10,2) NOT NULL CHECK (price > 0),
    stock_qty     INT DEFAULT 0,
    category_id   INT REFERENCES categories(category_id),
    created_at    TIMESTAMP DEFAULT NOW()
);

CREATE TABLE orders (
    order_id      SERIAL PRIMARY KEY,
    customer_id   INT NOT NULL REFERENCES customers(customer_id),
    order_date    TIMESTAMP DEFAULT NOW(),
    status        VARCHAR(20) CHECK (status IN 
                  ('pending','processing','shipped','delivered','cancelled')),
    total_amount  NUMERIC(12,2)
);

CREATE TABLE order_items (
    item_id       SERIAL PRIMARY KEY,
    order_id      INT NOT NULL REFERENCES orders(order_id),
    product_id    INT NOT NULL REFERENCES products(product_id),
    quantity      INT NOT NULL CHECK (quantity > 0),
    unit_price    NUMERIC(10,2) NOT NULL
);

-- ============================================
-- INDEXES - Optimized for common query patterns
-- ============================================
CREATE INDEX idx_orders_customer    ON orders(customer_id);
CREATE INDEX idx_orders_status_date ON orders(status, order_date DESC);
CREATE INDEX idx_order_items_order  ON order_items(order_id);
CREATE INDEX idx_products_category  ON products(category_id);
CREATE INDEX idx_customers_email    ON customers(email);

-- Partial index - only active customers
CREATE INDEX idx_active_customers 
    ON customers(email) WHERE is_active = TRUE;
