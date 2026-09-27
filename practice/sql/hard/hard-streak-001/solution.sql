-- Xom Data · Chuỗi tháng ghé đều dài nhất
-- Problem: https://xomdata.com/practice/hard-streak-001
-- Solved: 2026-09-27

WITH monthly_orders AS (
    SELECT DISTINCT
        customer_id,
        STRFTIME('%Y', order_date) * 12 + STRFTIME('%m', order_date) AS month_idx,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY STRFTIME('%Y-%m', order_date)) AS rn
    FROM orders
),
streak_groups AS (
    SELECT
        customer_id,
        month_idx,
        rn,
        month_idx - rn AS grp
    FROM monthly_orders
),
streak_count AS (
    SELECT
        customer_id,
        grp,
        COUNT(*) AS streak_count
    FROM streak_groups
    GROUP BY customer_id, grp
)
SELECT 
    customer_id,
    MAX(streak_count) AS longest_streak
FROM streak_count
GROUP BY customer_id
ORDER BY longest_streak DESC, customer_id
