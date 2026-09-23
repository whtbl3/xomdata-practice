-- Xom Data · Dự đoán ngày khách ghé tiếp theo
-- Problem: https://xomdata.com/practice/hard-gap-003
-- Solved: 2026-09-23

WITH m AS (
    SELECT
        customer_id
        , order_date
        , FIRST_VALUE(order_date) OVER (
            PARTITION BY customer_id
            ORDER BY order_date DESC
        ) AS last_order_date
        , julianday(order_date) 
            - julianday(LAG(order_date) OVER (
                                        PARTITION BY customer_id
                                        ORDER BY order_date)) AS date_diff
    FROM orders
),
a AS (
    SELECT
        customer_id
        , last_order_date
        , CAST(AVG(date_diff) AS INTEGER) AS avg_gap_days
    FROM m
    GROUP BY customer_id
    HAVING COUNT(customer_id) > 1
)
SELECT
    customer_id
    , last_order_date
    , avg_gap_days
    , DATE(last_order_date, '+' || avg_gap_days || ' days') AS predicted_next_date
FROM a
