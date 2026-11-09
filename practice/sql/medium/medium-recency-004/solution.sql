-- Xom Data · Three Freshness Circles of the Customer Base
-- Problem: https://xomdata.com/practice/medium-recency-004
-- Solved: 2026-11-09

WITH latest_orders AS (
    SELECT
        customer_id,
        MAX(order_date) AS last_order_date
    FROM orders
    GROUP BY customer_id
),
stat AS (
    SELECT
        customer_id,
        CASE
            WHEN (DATE '2024-06-30' - last_order_date::DATE) BETWEEN 0 AND 30 THEN 'hot'
            WHEN (DATE '2024-06-30' - last_order_date::DATE) BETWEEN 31 AND 90 THEN 'warm'
            ELSE 'cold'
        END AS freshness_bucket
    FROM latest_orders
)
SELECT
    freshness_bucket,
    COUNT(customer_id) AS customer_count
FROM stat
GROUP BY freshness_bucket
ORDER BY 
    CASE freshness_bucket
        WHEN 'hot' THEN 1
        WHEN 'warm' THEN 2
        WHEN 'cold' THEN 3
    END;
