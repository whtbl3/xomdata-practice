-- Xom Data · High-rated sellers with many orders
-- Problem: https://xomdata.com/practice/medium-having-019
-- Solved: 2026-09-08

WITH agg_order AS (
    SELECT 
        s.id AS seller_id,
        s.store_name,
        s.reputation_score,
        COUNT(o.id) AS order_count
    FROM orders o LEFT JOIN sellers s ON o.seller_id = s.id
    WHERE s.reputation_score >= 4.5 
    GROUP BY s.id
    HAVING order_count >= 3
)
SELECT 
    store_name,
    reputation_score,
    order_count,
    DENSE_RANK() OVER (ORDER BY order_count DESC) AS rank_by_orders,
    SUM(order_count) OVER (ORDER BY order_count DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) AS cumulative_orders
FROM agg_order
ORDER BY rank_by_orders, store_name
