-- Xom Data · Running inventory balance over time
-- Problem: https://xomdata.com/practice/hard-fifo-001
-- Solved: 2026-09-20

SELECT
    sku,
    occurred_at,
    type,
    quantity,
    SUM(
        CASE 
            WHEN type = 'IN' THEN quantity
            WHEN type = 'OUT' THEN -quantity
        END
    )
    OVER (
        PARTITION BY sku
        ORDER BY occurred_at
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW 
    ) AS running_balance
FROM inventory_movements
