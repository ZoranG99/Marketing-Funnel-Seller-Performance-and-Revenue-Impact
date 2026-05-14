-- Lead funnel view
CREATE OR REPLACE VIEW marketplace.vw_lead_funnel AS
SELECT
    mql.mql_id,
    mql.first_contact_date,
    mql.first_contact_year,
    mql.first_contact_month,
    mql.first_contact_month_start,
    mql.landing_page_id,
    mql.origin,

    cd.seller_id,
    cd.won_date,
    cd.won_year,
    cd.won_month,
    cd.won_month_start,
    cd.business_segment,
    cd.lead_type,
    cd.lead_behaviour_profile,
    cd.has_company,
    cd.has_gtin,
    cd.average_stock,
    cd.business_type,
    cd.declared_product_catalog_size,
    cd.declared_monthly_revenue,
    cd.seller_exists_in_sellers,
    cd.seller_has_orders,
    cd.days_to_close,
    cd.is_valid_sales_cycle,

    CASE 
        WHEN cd.mql_id IS NOT NULL THEN TRUE 
        ELSE FALSE 
    END AS is_closed_deal

FROM marketplace.marketing_qualified_leads AS mql
LEFT JOIN marketplace.closed_deals AS cd
    ON mql.mql_id = cd.mql_id;


-- Seller performance view
CREATE OR REPLACE VIEW marketplace.vw_seller_order_performance AS
WITH seller_order_items AS (
    SELECT
        seller_id,
        order_id,
        COUNT(*) AS items_sold,
        COUNT(DISTINCT product_id) AS unique_products_sold,
        SUM(price) AS seller_revenue,
        SUM(freight_value) AS freight_revenue,
        SUM(item_total_value) AS total_item_value
    FROM marketplace.order_items
    GROUP BY seller_id, order_id
),

order_review_summary AS (
    SELECT
        order_id,
        AVG(review_score) AS avg_review_score
    FROM marketplace.order_reviews
    GROUP BY order_id
)

SELECT
    soi.seller_id,

    COUNT(DISTINCT soi.order_id) AS total_orders,
    SUM(soi.items_sold) AS total_items_sold,
    SUM(soi.unique_products_sold) AS total_unique_products_sold,

    SUM(soi.seller_revenue) AS seller_revenue,
    SUM(soi.freight_revenue) AS freight_revenue,
    SUM(soi.total_item_value) AS total_item_value,

    AVG(soi.seller_revenue) AS avg_revenue_per_order,

    COUNT(DISTINCT o.customer_id) AS unique_customers,

    COUNT(*) FILTER (WHERE o.order_status = 'delivered') AS delivered_orders,
    COUNT(*) FILTER (WHERE o.is_late_delivery = TRUE) AS late_orders,

    AVG(o.delivery_days) AS avg_delivery_days,
    AVG(o.delivery_delay_days) AS avg_delivery_delay_days,
    AVG(ors.avg_review_score) AS avg_review_score

FROM seller_order_items AS soi
LEFT JOIN marketplace.orders AS o
    ON soi.order_id = o.order_id
LEFT JOIN order_review_summary AS ors
    ON soi.order_id = ors.order_id

GROUP BY soi.seller_id;


-- Converted seller performance view
CREATE OR REPLACE VIEW marketplace.vw_converted_seller_performance AS
SELECT
    lf.mql_id,
    lf.origin,
    lf.landing_page_id,
    lf.business_segment,
    lf.lead_type,
    lf.lead_behaviour_profile,
    lf.business_type,
    lf.won_date,
    lf.days_to_close,
    lf.is_valid_sales_cycle,
    lf.seller_id,
    lf.seller_exists_in_sellers,
    lf.seller_has_orders,

    sop.total_orders,
    sop.total_items_sold,
    sop.total_unique_products_sold,
    sop.seller_revenue,
    sop.freight_revenue,
    sop.total_item_value,
    sop.avg_revenue_per_order,
    sop.unique_customers,
    sop.delivered_orders,
    sop.late_orders,
    sop.avg_delivery_days,
    sop.avg_delivery_delay_days,
    sop.avg_review_score

FROM marketplace.vw_lead_funnel AS lf
LEFT JOIN marketplace.vw_seller_order_performance AS sop
    ON lf.seller_id = sop.seller_id

WHERE lf.is_closed_deal = TRUE;


-- Row count checks
SELECT 'vw_lead_funnel' AS view_name, COUNT(*) AS rows
FROM marketplace.vw_lead_funnel

UNION ALL

SELECT 'vw_seller_order_performance', COUNT(*)
FROM marketplace.vw_seller_order_performance

UNION ALL

SELECT 'vw_converted_seller_performance', COUNT(*)
FROM marketplace.vw_converted_seller_performance;