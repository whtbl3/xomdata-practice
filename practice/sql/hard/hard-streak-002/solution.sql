-- Xom Data · Ai đang giữ phong độ đến tận hôm nay
-- Problem: https://xomdata.com/practice/hard-streak-002
-- Solved: 2026-09-23

WITH m AS (
    SELECT DISTINCT
        customer_id,
        STRFTIME('%Y-%m', order_date) AS ym
    FROM orders
),
r AS (
    SELECT
        customer_id,
        ym,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY ym DESC
        ) AS rn,
        (CAST(STRFTIME('%Y', '2024-06-01')AS INT) - CAST(STRFTIME('%Y', ym || '-01') AS INT)) * 12
        + (CAST(STRFTIME('%m', '2024-06-01') AS INT) - CAST(STRFTIME('%m', ym || '-01') AS INT)) AS month_diff 
    FROM m
)
SELECT
    customer_id,
    COUNT(*) AS current_streak
FROM r
WHERE month_diff = rn - 1
GROUP BY customer_id
ORDER BY current_streak DESC, customer_id ASC
