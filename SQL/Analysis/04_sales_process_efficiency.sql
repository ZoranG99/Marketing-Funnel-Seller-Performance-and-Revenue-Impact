-- Question 4

-- How efficient is the sales process, 
-- and which lead segments take the longest to close?

SELECT
    origin AS marketing_channel,
    lead_type,
    business_segment,
    business_type,

    COUNT(mql_id) AS closed_deals,

    ROUND(AVG(days_to_close), 2) AS avg_days_to_close,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY days_to_close) AS median_days_to_close,
    MIN(days_to_close) AS min_days_to_close,
    MAX(days_to_close) AS max_days_to_close,

    COUNT(mql_id) FILTER (
        WHERE days_to_close <= 7
    ) AS closed_within_7_days,

    COUNT(mql_id) FILTER (
        WHERE days_to_close <= 30
    ) AS closed_within_30_days,

    ROUND(
        COUNT(mql_id) FILTER (WHERE days_to_close <= 30)::NUMERIC
        / COUNT(mql_id) * 100,
        2
    ) AS closed_within_30_days_rate,

    COUNT(mql_id) FILTER (
        WHERE seller_has_orders = TRUE
    ) AS active_converted_sellers,

    ROUND(
        COUNT(mql_id) FILTER (WHERE seller_has_orders = TRUE)::NUMERIC
        / COUNT(mql_id) * 100,
        2
    ) AS deal_to_active_seller_rate

FROM marketplace.vw_converted_seller_performance

WHERE is_valid_sales_cycle = TRUE
  AND days_to_close IS NOT NULL

GROUP BY
    origin,
    lead_type,
    business_segment,
    business_type

HAVING COUNT(mql_id) >= 5

ORDER BY
    avg_days_to_close DESC;