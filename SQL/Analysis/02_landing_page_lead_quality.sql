-- Question 2

-- Which landing pages attract the highest-quality leads 
-- based on conversion rate and downstream seller revenue?

SELECT
    lf.landing_page_id,

    COUNT(lf.mql_id) AS total_mqls,

    COUNT(lf.mql_id) FILTER (
        WHERE lf.is_closed_deal = TRUE
    ) AS closed_deals,

    ROUND(
        COUNT(lf.mql_id) FILTER (WHERE lf.is_closed_deal = TRUE)::NUMERIC
        / COUNT(lf.mql_id) * 100,
        2
    ) AS mql_to_deal_conversion_rate,

    COUNT(lf.mql_id) FILTER (
        WHERE lf.seller_has_orders = TRUE
    ) AS active_converted_sellers,

    ROUND(
        COUNT(lf.mql_id) FILTER (WHERE lf.seller_has_orders = TRUE)::NUMERIC
        / NULLIF(COUNT(lf.mql_id), 0) * 100,
        2
    ) AS mql_to_active_seller_rate,

    ROUND(SUM(COALESCE(csp.seller_revenue, 0)), 2) AS total_seller_revenue,

    ROUND(
        SUM(COALESCE(csp.seller_revenue, 0))
        / NULLIF(COUNT(lf.mql_id), 0),
        2
    ) AS revenue_per_mql,

    ROUND(
        SUM(COALESCE(csp.seller_revenue, 0))
        / NULLIF(COUNT(lf.mql_id) FILTER (WHERE lf.is_closed_deal = TRUE), 0),
        2
    ) AS revenue_per_closed_deal,

    ROUND(AVG(lf.days_to_close), 2) AS avg_days_to_close,

    ROUND(AVG(csp.avg_review_score), 2) AS avg_review_score

FROM marketplace.vw_lead_funnel AS lf
LEFT JOIN marketplace.vw_converted_seller_performance AS csp
    ON lf.mql_id = csp.mql_id

GROUP BY
    lf.landing_page_id

HAVING COUNT(lf.mql_id) >= 20

ORDER BY
    total_seller_revenue DESC;