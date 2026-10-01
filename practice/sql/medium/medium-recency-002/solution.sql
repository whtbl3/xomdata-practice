-- Xom Data · Ba mươi ngày vắng bóng
-- Problem: https://xomdata.com/practice/medium-recency-002
-- Solved: 2026-10-01

SELECT
    customer_id,
    MAX(order_date) AS last_order_date
FROM orders
GROUP BY customer_id
HAVING julianday('2024-06-30') - julianday(MAX(order_date)) > 30
