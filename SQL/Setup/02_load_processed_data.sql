-- Load the data
COPY marketplace.customers
FROM 'D:/Data_Science/Projects/Portfolio_Projects/Marketing_Funnel_Seller_Performance_and_Revenue_Impact/Dataset/Processed/customers.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    NULL '',
    ENCODING 'UTF8'
);

COPY marketplace.sellers
FROM 'D:/Data_Science/Projects/Portfolio_Projects/Marketing_Funnel_Seller_Performance_and_Revenue_Impact/Dataset/Processed/sellers.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    NULL '',
    ENCODING 'UTF8'
);

COPY marketplace.geolocation
FROM 'D:/Data_Science/Projects/Portfolio_Projects/Marketing_Funnel_Seller_Performance_and_Revenue_Impact/Dataset/Processed/geolocation.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    NULL '',
    ENCODING 'UTF8'
);

COPY marketplace.product_category_translation
FROM 'D:/Data_Science/Projects/Portfolio_Projects/Marketing_Funnel_Seller_Performance_and_Revenue_Impact/Dataset/Processed/product_category_translation.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    NULL '',
    ENCODING 'UTF8'
);

COPY marketplace.products
FROM 'D:/Data_Science/Projects/Portfolio_Projects/Marketing_Funnel_Seller_Performance_and_Revenue_Impact/Dataset/Processed/products.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    NULL '',
    ENCODING 'UTF8'
);

COPY marketplace.marketing_qualified_leads
FROM 'D:/Data_Science/Projects/Portfolio_Projects/Marketing_Funnel_Seller_Performance_and_Revenue_Impact/Dataset/Processed/marketing_qualified_leads.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    NULL '',
    ENCODING 'UTF8'
);

COPY marketplace.closed_deals
FROM 'D:/Data_Science/Projects/Portfolio_Projects/Marketing_Funnel_Seller_Performance_and_Revenue_Impact/Dataset/Processed/closed_deals.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    NULL '',
    ENCODING 'UTF8'
);

COPY marketplace.orders
FROM 'D:/Data_Science/Projects/Portfolio_Projects/Marketing_Funnel_Seller_Performance_and_Revenue_Impact/Dataset/Processed/orders.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    NULL '',
    ENCODING 'UTF8'
);

COPY marketplace.order_items
FROM 'D:/Data_Science/Projects/Portfolio_Projects/Marketing_Funnel_Seller_Performance_and_Revenue_Impact/Dataset/Processed/order_items.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    NULL '',
    ENCODING 'UTF8'
);

COPY marketplace.order_payments
FROM 'D:/Data_Science/Projects/Portfolio_Projects/Marketing_Funnel_Seller_Performance_and_Revenue_Impact/Dataset/Processed/order_payments.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    NULL '',
    ENCODING 'UTF8'
);

COPY marketplace.order_reviews
FROM 'D:/Data_Science/Projects/Portfolio_Projects/Marketing_Funnel_Seller_Performance_and_Revenue_Impact/Dataset/Processed/order_reviews.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    NULL '',
    ENCODING 'UTF8'
);


-- Check row counts
SELECT 'customers' AS table_name, COUNT(*) AS rows FROM marketplace.customers
UNION ALL
SELECT 'sellers', COUNT(*) FROM marketplace.sellers
UNION ALL
SELECT 'geolocation', COUNT(*) FROM marketplace.geolocation
UNION ALL
SELECT 'product_category_translation', COUNT(*) FROM marketplace.product_category_translation
UNION ALL
SELECT 'products', COUNT(*) FROM marketplace.products
UNION ALL
SELECT 'marketing_qualified_leads', COUNT(*) FROM marketplace.marketing_qualified_leads
UNION ALL
SELECT 'closed_deals', COUNT(*) FROM marketplace.closed_deals
UNION ALL
SELECT 'orders', COUNT(*) FROM marketplace.orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM marketplace.order_items
UNION ALL
SELECT 'order_payments', COUNT(*) FROM marketplace.order_payments
UNION ALL
SELECT 'order_reviews', COUNT(*) FROM marketplace.order_reviews;