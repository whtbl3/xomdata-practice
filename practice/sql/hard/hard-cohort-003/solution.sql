-- Xom Data · Người mới và người quen mỗi tháng
-- Problem: https://xomdata.com/practice/hard-cohort-003
-- Solved: 2026-09-24

WITH monthly_orders AS (
    SELECT DISTINCT
        customer_id,
        STRFTIME('%Y-%m', order_date) AS ym,
        CASE 
            WHEN STRFTIME('%Y-%m', order_date) 
                > MIN(STRFTIME('%Y-%m', order_date)) OVER (
                    PARTITION BY customer_id
                ) THEN 1
            ELSE 0
        END AS existed_customer
    FROM orders
)
SELECT
    ym AS month,
    SUM(CASE WHEN existed_customer = 0 THEN 1 ELSE 0 END) AS new_customers,
    SUM(CASE WHEN existed_customer = 1 THEN 1 ELSE 0 END) AS returning_customers
FROM monthly_orders
GROUP BY month
ORDER BY month
