-- Xom Data · What the First Impression Was Worth
-- Problem: https://xomdata.com/practice/medium-firstlast-003
-- Solved: 2026-11-09

WITH first_order AS (
    SELECT
        customer_id,
        order_date,
        amount,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date, customer_id) AS rn
    FROM orders
)
SELECT
    customer_id,
    order_date AS first_order_date,
    amount AS first_amount
FROM first_order
WHERE rn = 1
ORDER BY customer_id
