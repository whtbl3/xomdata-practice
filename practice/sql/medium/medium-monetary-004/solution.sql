-- Xom Data · Đơn hàng để đời của mỗi khách
-- Problem: https://xomdata.com/practice/medium-monetary-004
-- Solved: 2026-09-29

WITH ranked AS (
    SELECT
        customer_id,
        order_id,
        order_date,
        amount,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY amount DESC, order_date ASC
        ) AS rn
    FROM orders
) 
SELECT
    customer_id,
    order_id,
    order_date,
    amount
FROM ranked WHERE rn = 1
ORDER BY customer_id ASC;
