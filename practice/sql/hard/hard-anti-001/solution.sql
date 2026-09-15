-- Xom Data · Customers silent for 90 days
-- Problem: https://xomdata.com/practice/hard-anti-001
-- Solved: 2026-09-15

WITH max_date AS (
    SELECT MAX(order_date) AS cutoff_date 
    FROM orders
)
SELECT 
    o.user_id,
    MAX(o.order_date) AS last_order_date,
    CAST(julianday(m.cutoff_date) - julianday(MAX(o.order_date)) AS INTEGER) AS days_since_last
FROM orders o
CROSS JOIN max_date m
GROUP BY o.user_id
HAVING days_since_last >= 90
ORDER BY days_since_last DESC, o.user_id ASC;
