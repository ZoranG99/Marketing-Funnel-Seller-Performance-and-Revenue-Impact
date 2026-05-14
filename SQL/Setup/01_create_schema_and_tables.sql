-- Create schema
DROP SCHEMA IF EXISTS marketplace CASCADE;
CREATE SCHEMA IF NOT EXISTS marketplace;


-- Drop old tables
DROP TABLE IF EXISTS marketplace.order_reviews CASCADE;
DROP TABLE IF EXISTS marketplace.order_payments CASCADE;
DROP TABLE IF EXISTS marketplace.order_items CASCADE;
DROP TABLE IF EXISTS marketplace.orders CASCADE;
DROP TABLE IF EXISTS marketplace.closed_deals CASCADE;
DROP TABLE IF EXISTS marketplace.marketing_qualified_leads CASCADE;
DROP TABLE IF EXISTS marketplace.products CASCADE;
DROP TABLE IF EXISTS marketplace.product_category_translation CASCADE;
DROP TABLE IF EXISTS marketplace.geolocation CASCADE;
DROP TABLE IF EXISTS marketplace.sellers CASCADE;
DROP TABLE IF EXISTS marketplace.customers CASCADE;


-- Create tables
CREATE TABLE marketplace.customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix VARCHAR(5),
    customer_city VARCHAR(150),
    customer_state CHAR(2)
);

CREATE TABLE marketplace.sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix VARCHAR(5),
    seller_city VARCHAR(150),
    seller_state CHAR(2)
);

CREATE TABLE marketplace.geolocation (
    geolocation_zip_code_prefix VARCHAR(5),
    geolocation_lat DOUBLE PRECISION,
    geolocation_lng DOUBLE PRECISION,
    geolocation_city VARCHAR(150),
    geolocation_state CHAR(2)
);

CREATE TABLE marketplace.product_category_translation (
    product_category_name VARCHAR(150) PRIMARY KEY,
    product_category_name_english VARCHAR(150)
);

CREATE TABLE marketplace.products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(150),
    product_name_length NUMERIC,
    product_description_length NUMERIC,
    product_photos_qty NUMERIC,
    product_weight_g NUMERIC,
    product_length_cm NUMERIC,
    product_height_cm NUMERIC,
    product_width_cm NUMERIC,
    product_volume_cm3 NUMERIC,

    CONSTRAINT fk_products_category
        FOREIGN KEY (product_category_name)
        REFERENCES marketplace.product_category_translation(product_category_name)
);

CREATE TABLE marketplace.marketing_qualified_leads (
    mql_id VARCHAR(50) PRIMARY KEY,
    first_contact_date TIMESTAMP,
    landing_page_id VARCHAR(50),
    origin VARCHAR(100),
    first_contact_year INTEGER,
    first_contact_month INTEGER,
    first_contact_month_start TIMESTAMP
);

CREATE TABLE marketplace.closed_deals (
    mql_id VARCHAR(50) PRIMARY KEY,
    seller_id VARCHAR(50),
    sdr_id VARCHAR(50),
    sr_id VARCHAR(50),
    won_date TIMESTAMP,
    business_segment VARCHAR(150),
    lead_type VARCHAR(100),
    lead_behaviour_profile VARCHAR(100),
    has_company BOOLEAN,
    has_gtin BOOLEAN,
    average_stock VARCHAR(100),
    business_type VARCHAR(100),
    declared_product_catalog_size NUMERIC,
    declared_monthly_revenue NUMERIC,
    seller_exists_in_sellers BOOLEAN,
    seller_has_orders BOOLEAN,
    first_contact_date TIMESTAMP,
    won_year INTEGER,
    won_month INTEGER,
    won_month_start TIMESTAMP,
    days_to_close NUMERIC,
    is_valid_sales_cycle BOOLEAN,

    CONSTRAINT fk_closed_deals_mql
        FOREIGN KEY (mql_id)
        REFERENCES marketplace.marketing_qualified_leads(mql_id)
);

CREATE TABLE marketplace.orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(50),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP,
    purchase_year INTEGER,
    purchase_month INTEGER,
    purchase_month_start TIMESTAMP,
    approval_days NUMERIC,
    delivery_days NUMERIC,
    estimated_delivery_days NUMERIC,
    delivery_delay_days NUMERIC,
    is_late_delivery BOOLEAN,

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES marketplace.customers(customer_id)
);

CREATE TABLE marketplace.order_items (
    order_id VARCHAR(50),
    order_item_id INTEGER,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date TIMESTAMP,
    price NUMERIC(12, 2),
    freight_value NUMERIC(12, 2),
    item_total_value NUMERIC(12, 2),

    PRIMARY KEY (order_id, order_item_id),

    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id)
        REFERENCES marketplace.orders(order_id),

    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id)
        REFERENCES marketplace.products(product_id),

    CONSTRAINT fk_order_items_seller
        FOREIGN KEY (seller_id)
        REFERENCES marketplace.sellers(seller_id)
);

CREATE TABLE marketplace.order_payments (
    order_id VARCHAR(50),
    payment_sequential INTEGER,
    payment_type VARCHAR(50),
    payment_installments INTEGER,
    payment_value NUMERIC(12, 2),
    is_installment_payment BOOLEAN,

    PRIMARY KEY (order_id, payment_sequential),

    CONSTRAINT fk_order_payments_order
        FOREIGN KEY (order_id)
        REFERENCES marketplace.orders(order_id)
);

CREATE TABLE marketplace.order_reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score INTEGER,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP,
    has_review_comment BOOLEAN,
    review_response_time_hours NUMERIC,

    CONSTRAINT fk_order_reviews_order
        FOREIGN KEY (order_id)
        REFERENCES marketplace.orders(order_id)
);