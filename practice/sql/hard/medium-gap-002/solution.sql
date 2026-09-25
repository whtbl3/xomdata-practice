-- Xom Data · Bao lâu thì khách quyết định quay lại lần hai
-- Problem: https://xomdata.com/practice/medium-gap-002
-- Solved: 2026-09-25

WITH second_orders AS (
    SELECT 
        customer_id,
        order_date AS first_order_date,
        LEAD(order_date) OVER (
            PARTITION BY customer_id
            ORDER BY order_date, order_id
        ) AS second_order_date ,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY order_date, order_id
        ) rn
    FROM orders
)
SELECT
    customer_id,
    first_order_date,
    second_order_date ,
    julianday(second_order_date) - julianday(first_order_date) AS days_between
FROM second_orders
WHERE second_order_date  IS NOT NULL AND rn = 1
