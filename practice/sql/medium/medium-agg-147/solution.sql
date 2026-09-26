-- Xom Data · Top 10 highest-profit dishes
-- Problem: https://xomdata.com/practice/medium-agg-147
-- Solved: 2026-09-26

WITH orders_stats AS (
    SELECT
        d.dish_name,
        c.category_name,
        SUM(quantity) AS total_sold,
        SUM(oi.quantity * oi.unit_price) AS revenue,
        SUM(oi.quantity * oi.unit_price) - SUM(oi.quantity * d.cost_price) AS profit,
        ROUND(100.0 * SUM(oi.quantity * (oi.unit_price - d.cost_price)) 
                / NULLIF(SUM(oi.quantity * oi.unit_price), 0), 2) AS margin_pct
    FROM order_items oi 
        JOIN orders o       ON oi.order_id = o.id
        JOIN dishes d       ON oi.dish_id = d.id
        JOIN categories c   ON d.category_id = c.id
    WHERE o.status = 'Completed'
    GROUP BY oi.dish_id, c.category_name, d.dish_name
),
orders_summary AS (
    SELECT
        *,
        RANK() OVER (ORDER BY profit DESC) AS rank_by_profit,
        RANK() OVER (ORDER BY margin_pct DESC) AS rank_by_margin
    FROM orders_stats
    ORDER BY profit DESC, dish_name
)
SELECT *
FROM orders_summary
LIMIT 10;
