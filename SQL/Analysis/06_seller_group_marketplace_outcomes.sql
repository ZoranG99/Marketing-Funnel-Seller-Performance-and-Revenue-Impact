-- Question 6

-- Which converted seller groups create the strongest marketplace outcomes 
-- in revenue, orders, product categories, review scores, and delivery performance?

SELECT
    csp.business_segment,
    csp.lead_type,
    csp.business_type,

    COUNT(csp.mql_id) AS closed_deals,

    COUNT(csp.mql_id) FILTER (
        WHERE csp.seller_has_orders = TRUE
    ) AS active_converted_sellers,

    ROUND(
        COUNT(csp.mql_id) FILTER (WHERE csp.seller_has_orders = TRUE)::NUMERIC
        / COUNT(csp.mql_id) * 100,
        2
    ) AS active_seller_rate,

    ROUND(SUM(COALESCE(csp.seller_revenue, 0)), 2) AS total_seller_revenue,

    ROUND(AVG(csp.seller_revenue), 2) AS avg_revenue_per_active_seller,

    ROUND(SUM(COALESCE(csp.total_orders, 0)), 0) AS total_orders,

    ROUND(AVG(csp.total_orders), 2) AS avg_orders_per_active_seller,

    ROUND(AVG(csp.avg_revenue_per_order), 2) AS avg_revenue_per_order,

    ROUND(AVG(csp.avg_review_score), 2) AS avg_review_score,

    ROUND(AVG(csp.avg_delivery_days), 2) AS avg_delivery_days,

    ROUND(AVG(csp.avg_delivery_delay_days), 2) AS avg_delivery_delay_days,

    ROUND(
        SUM(COALESCE(csp.late_orders, 0))::NUMERIC
        / NULLIF(SUM(COALESCE(csp.delivered_orders, 0)), 0) * 100,
        2
    ) AS late_delivery_rate

FROM marketplace.vw_converted_seller_performance AS csp

GROUP BY
    csp.business_segment,
    csp.lead_type,
    csp.business_type

HAVING COUNT(csp.mql_id) >= 5

ORDER BY
    total_seller_revenue DESC;