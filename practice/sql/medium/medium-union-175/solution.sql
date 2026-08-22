-- Xom Data · Summary of issues to handle
-- Problem: https://xomdata.com/practice/medium-union-175
-- Solved: 2026-08-22

WITH CTE_type_and_quantity AS
(SELECT  
    'Complaint' AS type,
    (COUNT (status)) AS quantity
FROM complaints
WHERE status = 'Pending'
UNION ALL
SELECT
    'Cancelled Order' AS type,
    (COUNT (status)) AS quantity
FROM orders
WHERE  status = 'Cancelled'
UNION ALL
SELECT
    'Out of Stock Product' AS type,
    (COUNT (status)) AS quantity
FROM products
WHERE status = 'Out of Stock')
, CTE_calculation AS
(
SELECT
    type,
    quantity,
    quantity * 100.0 / NULLIF(SUM(quantity) OVER (),0) AS pct,
    RANK() OVER (ORDER BY quantity DESC) AS rank_pos
FROM CTE_type_and_quantity
)
SELECT 
    type,
    quantity,
    ROUND(pct, 2) AS pct_of_total,
    rank_pos,
    ROUND(SUM (pct) OVER (ORDER BY rank_pos, type),2) AS cumulative_pct
FROM CTE_Calculation
ORDER BY rank_pos, type
