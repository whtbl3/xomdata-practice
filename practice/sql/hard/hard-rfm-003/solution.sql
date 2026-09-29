-- Xom Data · Điểm tươi mới cộng điểm chuyên cần
-- Problem: https://xomdata.com/practice/hard-rfm-003
-- Solved: 2026-09-29

WITH customer_rfm AS (
    SELECT
        customer_id,
        6 - NTILE(5) OVER (
            ORDER BY MAX(order_date) DESC, customer_id ASC
        ) r_score,
        CASE
            WHEN COUNT(order_id) >= 8 THEN 3
            WHEN COUNT(order_id) >= 4 THEN 2
            ELSE 1
        END AS f_score
    FROM orders
    WHERE order_date <= '2024-06-30'
    GROUP BY customer_id
)
SELECT
    customer_id,
    r_score,
    f_score,
    (r_score + f_score) AS total_score,
    CASE
        WHEN (r_score + f_score) >= 7 THEN 'Gold'
        WHEN (r_score + f_score) >= 5 then 'Silver'
        ELSE 'Bronze'
    END AS label
FROM customer_rfm;
