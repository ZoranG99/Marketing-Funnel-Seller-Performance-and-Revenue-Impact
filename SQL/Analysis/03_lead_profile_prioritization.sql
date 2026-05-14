-- Question 3

-- Which lead profiles should the sales team prioritize 
-- based on conversion probability and expected business impact?

SELECT
    lf.lead_type,
    lf.business_segment,
    lf.lead_behaviour_profile,
    lf.business_type,

    COUNT(lf.mql_id) AS closed_deals,

    COUNT(lf.mql_id) FILTER (
        WHERE lf.seller_has_orders = TRUE
    ) AS active_converted_sellers,

    ROUND(
        COUNT(lf.mql_id) FILTER (WHERE lf.seller_has_orders = TRUE)::NUMERIC
        / COUNT(lf.mql_id) * 100,
        2
    ) AS deal_to_active_seller_rate,

    ROUND(SUM(COALESCE(csp.seller_revenue, 0)), 2) AS total_seller_revenue,

    ROUND(
        SUM(COALESCE(csp.seller_revenue, 0))
        / NULLIF(COUNT(lf.mql_id), 0),
        2
    ) AS revenue_per_closed_deal,

    ROUND(
        SUM(COALESCE(csp.seller_revenue, 0))
        / NULLIF(COUNT(lf.mql_id) FILTER (WHERE lf.seller_has_orders = TRUE), 0),
        2
    ) AS revenue_per_active_seller,

    ROUND(AVG(lf.days_to_close), 2) AS avg_days_to_close,

    ROUND(AVG(csp.avg_review_score), 2) AS avg_review_score

FROM marketplace.vw_converted_seller_performance AS csp
JOIN marketplace.vw_lead_funnel AS lf
    ON csp.mql_id = lf.mql_id

WHERE lf.is_closed_deal = TRUE

GROUP BY
    lf.lead_type,
    lf.business_segment,
    lf.lead_behaviour_profile,
    lf.business_type

HAVING COUNT(lf.mql_id) >= 5

ORDER BY
    total_seller_revenue DESC;