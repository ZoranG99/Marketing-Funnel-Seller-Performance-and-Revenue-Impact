-- Create indexes to improve query performance on frequently used columns
CREATE INDEX IF NOT EXISTS idx_orders_customer_id
ON marketplace.orders(customer_id);

CREATE INDEX IF NOT EXISTS idx_orders_purchase_date
ON marketplace.orders(order_purchase_timestamp);

CREATE INDEX IF NOT EXISTS idx_order_items_order_id
ON marketplace.order_items(order_id);

CREATE INDEX IF NOT EXISTS idx_order_items_seller_id
ON marketplace.order_items(seller_id);

CREATE INDEX IF NOT EXISTS idx_order_items_product_id
ON marketplace.order_items(product_id);

CREATE INDEX IF NOT EXISTS idx_order_payments_order_id
ON marketplace.order_payments(order_id);

CREATE INDEX IF NOT EXISTS idx_order_reviews_order_id
ON marketplace.order_reviews(order_id);

CREATE INDEX IF NOT EXISTS idx_closed_deals_seller_id
ON marketplace.closed_deals(seller_id);

CREATE INDEX IF NOT EXISTS idx_closed_deals_won_date
ON marketplace.closed_deals(won_date);

CREATE INDEX IF NOT EXISTS idx_mql_origin
ON marketplace.marketing_qualified_leads(origin);

CREATE INDEX IF NOT EXISTS idx_mql_landing_page
ON marketplace.marketing_qualified_leads(landing_page_id);

CREATE INDEX IF NOT EXISTS idx_mql_first_contact_date
ON marketplace.marketing_qualified_leads(first_contact_date);


-- Show all indexes in the marketplace schema
SELECT
    schemaname,
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE schemaname = 'marketplace'
ORDER BY tablename, indexname;


-- Show only custom indexes with names starting with idx_
SELECT
    schemaname,
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE schemaname = 'marketplace'
  AND indexname LIKE 'idx_%'
ORDER BY tablename, indexname;


-- Count how many indexes each table has
SELECT
    schemaname,
    tablename,
    COUNT(*) AS index_count
FROM pg_indexes
WHERE schemaname = 'marketplace'
GROUP BY schemaname, tablename
ORDER BY tablename;