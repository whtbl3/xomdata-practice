-- Xom Data · Portfolio profit/loss
-- Problem: https://xomdata.com/practice/medium-casewhen-047
-- Solved: 2026-09-20

WITH cte1 AS (
    SELECT 
        s.stock_code,
        c.stock_quantity,
        c.avg_cost_price,
        s.current_price,
        ROUND((s.current_price - c.avg_cost_price) * c.stock_quantity, 0) AS profit_loss,
        ROUND((s.current_price - c.avg_cost_price) / c.avg_cost_price * 100.0, 2) AS profit_pct
    FROM categories c JOIN stocks s ON c.stock_id = s.id
),
cte2 AS (
    SELECT
        stock_code,
        stock_quantity,
        avg_cost_price,
        current_price,
        profit_loss,
        profit_pct,
        CASE
            WHEN profit_pct > 10.0 THEN 'Strong Gain'
            WHEN profit_pct > 0.0 THEN 'Mild Gain'
            WHEN profit_pct = 0.0 THEN 'Break Even'
            WHEN profit_pct > - 10.0 THEN 'Mild Loss'
            ELSE 'Strong Loss'
        END AS status,
        RANK() OVER (ORDER BY profit_pct DESC) AS rank_by_pct,
        SUM(avg_cost_price * stock_quantity)
            OVER (
                ORDER BY profit_pct DESC, stock_code ASC
        ) AS cumulative_invested
    FROM cte1
) SELECT * FROM cte2
