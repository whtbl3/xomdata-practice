-- Xom Data · How Long Since a Customer Last Returned
-- Problem: https://xomdata.com/practice/medium-recency-001
-- Solved: 2026-10-01

SELECT
    customer_id,
    MAX(order_date) AS last_order_date,
    julianday('2024-06-30') - julianday(MAX(order_date)) AS days_since
FROM orders
GROUP BY customer_id
ORDER BY days_since, customer_id;
