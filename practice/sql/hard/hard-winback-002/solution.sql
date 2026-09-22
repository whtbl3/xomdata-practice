-- Xom Data · Đếm những sự trở lại mỗi tháng
-- Problem: https://xomdata.com/practice/hard-winback-002
-- Solved: 2026-09-22

WITH active_month AS (
    SELECT DISTINCT
        customer_id,
        STRFTIME('%Y-%m', order_date) AS current_month
    FROM orders
),
prev_month AS (
    SELECT
        customer_id,
        current_month,
        LAG(current_month) OVER (
            PARTITION BY customer_id
            ORDER BY current_month
        ) AS previous_month
    FROM active_month
) 
SELECT 
    current_month AS month, 
    COUNT(*) AS resurrected_customers
FROM prev_month
WHERE previous_month IS NOT NULL 
  AND julianday(current_month || '-01') - julianday(previous_month || '-01') >= 80
GROUP BY current_month
ORDER BY month ASC;
