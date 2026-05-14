-- Question 5

-- Do converted sellers become active marketplace sellers after closing?

-- Overall post-closing seller activation and performance
SELECT
    COUNT(*) AS total_closed_deals,

    COUNT(*) FILTER (
        WHERE seller_has_orders = TRUE
    ) AS active_converted_sellers,

    COUNT(*) FILTER (
        WHERE seller_has_orders = FALSE
    ) AS inactive_converted_sellers,

    ROUND(
        COUNT(*) FILTER (WHERE seller_has_orders = TRUE)::NUMERIC
        / COUNT(*) * 100,
        2
    ) AS active_seller_rate,

    ROUND(
        COUNT(*) FILTER (WHERE seller_has_orders = FALSE)::NUMERIC
        / COUNT(*) * 100,
        2
    ) AS inactive_seller_rate,

    ROUND(SUM(COALESCE(seller_revenue, 0)), 2) AS total_seller_revenue,

    ROUND(AVG(seller_revenue), 2) AS avg_revenue_per_active_seller,

    ROUND(AVG(total_orders), 2) AS avg_orders_per_active_seller,

    ROUND(AVG(avg_review_score), 2) AS avg_review_score

FROM marketplace.vw_converted_seller_performance;


-- Post-closing seller activation and performance by marketing channel
SELECT
    origin AS marketing_channel,

    COUNT(*) AS closed_deals,

    COUNT(*) FILTER (
        WHERE seller_has_orders = TRUE
    ) AS active_converted_sellers,

    COUNT(*) FILTER (
        WHERE seller_has_orders = FALSE
    ) AS inactive_converted_sellers,

    ROUND(
        COUNT(*) FILTER (WHERE seller_has_orders = TRUE)::NUMERIC
        / COUNT(*) * 100,
        2
    ) AS active_seller_rate,

    ROUND(SUM(COALESCE(seller_revenue, 0)), 2) AS total_seller_revenue,

    ROUND(
        SUM(COALESCE(seller_revenue, 0))
        / NULLIF(COUNT(*) FILTER (WHERE seller_has_orders = TRUE), 0),
        2
    ) AS revenue_per_active_seller,

    ROUND(AVG(total_orders), 2) AS avg_orders_per_active_seller,

    ROUND(AVG(avg_review_score), 2) AS avg_review_score

FROM marketplace.vw_converted_seller_performance

GROUP BY
    origin

ORDER BY
    total_seller_revenue DESC;