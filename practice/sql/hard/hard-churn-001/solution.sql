-- Xom Data · Churned and returning customers
-- Problem: https://xomdata.com/practice/hard-churn-001
-- Solved: 2026-09-16

WITH next_order_date AS (
    SELECT
        user_id,
        order_date AS prev_order,
        LEAD(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS next_order
    FROM orders
)
SELECT
    user_id,
    prev_order,
    next_order,
    julianday(next_order) - julianday(prev_order) AS gap_days
FROM next_order_date
WHERE next_order IS NOT NULL AND gap_days >= 90
ORDER BY gap_days DESC, user_id ASC;
