-- Xom Data · Customer spending per order
-- Problem: https://xomdata.com/practice/medium-join-001
-- Solved: 2026-09-07

WITH agg AS (
    SELECT
        c.full_name,
        COUNT(o.id) AS order_count,
        COALESCE(SUM(o.total_amount), 0) AS total_spending,
        COALESCE(ROUND(AVG(o.total_amount), 0), 0) AS avg_order_value
    FROM customers c LEFT JOIN orders o ON c.id = o.customer_id
    GROUP BY c.id
)
SELECT 
    full_name,
    order_count,
    total_spending,
    avg_order_value,
    ROW_NUMBER() OVER (ORDER BY total_spending DESC, full_name ASC) AS spending_rank
FROM agg
