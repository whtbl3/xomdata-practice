-- Xom Data · Chốt được đơn thứ hai trong một tháng
-- Problem: https://xomdata.com/practice/medium-repeat-004
-- Solved: 2026-09-17

WITH rank_order AS (
    SELECT
        customer_id,
        order_date,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date, order_id) AS rn
    FROM orders
),
second_order_date AS (
    SELECT
        o1.customer_id,
        o1.order_date AS first_order_date,
        o2.order_date AS second_order_date,
        julianday(o2.order_date) - julianday(o1.order_date) AS days_to_second
    FROM rank_order o1 JOIN rank_order o2 ON o1.customer_id = o2.customer_id AND o1.rn = 1 AND o2.rn = 2
) SELECT * FROM second_order_date WHERE days_to_second <= 30
