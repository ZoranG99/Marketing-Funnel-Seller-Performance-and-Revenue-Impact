-- Check primary key uniqueness / row integrity
SELECT 'customers' AS table_name, COUNT(*) AS rows, COUNT(DISTINCT customer_id) AS unique_ids
FROM marketplace.customers
UNION ALL
SELECT 'orders', COUNT(*), COUNT(DISTINCT order_id)
FROM marketplace.orders
UNION ALL
SELECT 'products', COUNT(*), COUNT(DISTINCT product_id)
FROM marketplace.products
UNION ALL
SELECT 'sellers', COUNT(*), COUNT(DISTINCT seller_id)
FROM marketplace.sellers
UNION ALL
SELECT 'marketing_qualified_leads', COUNT(*), COUNT(DISTINCT mql_id)
FROM marketplace.marketing_qualified_leads
UNION ALL
SELECT 'closed_deals', COUNT(*), COUNT(DISTINCT mql_id)
FROM marketplace.closed_deals;


-- Validate key business issue: converted sellers missing from sellers table
SELECT
    COUNT(*) AS total_closed_deals,
    COUNT(*) FILTER (WHERE seller_exists_in_sellers = TRUE) AS sellers_found_in_sellers_table,
    COUNT(*) FILTER (WHERE seller_exists_in_sellers = FALSE) AS sellers_not_found_in_sellers_table,
    COUNT(*) FILTER (WHERE seller_has_orders = TRUE) AS converted_sellers_with_orders,
    COUNT(*) FILTER (WHERE seller_has_orders = FALSE) AS converted_sellers_without_orders
FROM marketplace.closed_deals;


-- Check date ranges after import
SELECT
    'mql_first_contact' AS date_field,
    MIN(first_contact_date) AS min_date,
    MAX(first_contact_date) AS max_date
FROM marketplace.marketing_qualified_leads

UNION ALL

SELECT
    'closed_deals_won_date',
    MIN(won_date),
    MAX(won_date)
FROM marketplace.closed_deals

UNION ALL

SELECT
    'orders_purchase_date',
    MIN(order_purchase_timestamp),
    MAX(order_purchase_timestamp)
FROM marketplace.orders

UNION ALL

SELECT
    'reviews_creation_date',
    MIN(review_creation_date),
    MAX(review_creation_date)
FROM marketplace.order_reviews;


-- Inspect primary keys
SELECT
    tc.table_schema,
    tc.table_name,
    tc.constraint_name,
    kcu.column_name,
    kcu.ordinal_position
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
WHERE tc.table_schema = 'marketplace'
  AND tc.constraint_type = 'PRIMARY KEY'
ORDER BY
    tc.table_name,
    kcu.ordinal_position;


-- Inspect foreign keys
SELECT
    tc.table_schema,
    tc.table_name,
    tc.constraint_name,
    kcu.column_name AS foreign_key_column,
    ccu.table_schema AS referenced_table_schema,
    ccu.table_name AS referenced_table_name,
    ccu.column_name AS referenced_column_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
    AND ccu.table_schema = tc.table_schema
WHERE tc.table_schema = 'marketplace'
  AND tc.constraint_type = 'FOREIGN KEY'
ORDER BY
    tc.table_name,
    tc.constraint_name;


-- Inspect all constraints
SELECT
    table_schema,
    table_name,
    constraint_name,
    constraint_type
FROM information_schema.table_constraints
WHERE table_schema = 'marketplace'
ORDER BY
    table_name,
    constraint_type,
    constraint_name;
