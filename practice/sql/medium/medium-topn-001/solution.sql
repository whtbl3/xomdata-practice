-- Xom Data · Sales champion of each region
-- Problem: https://xomdata.com/practice/medium-topn-001
-- Solved: 2026-10-21

-- Write your SQL here
WITH t AS (
    SELECT
        region,
        rep_name,
        sales_amount,
        ROW_NUMBER() OVER (PARTITION BY region ORDER BY sales_amount DESC, rep_name ASC) AS rn
    FROM reps
) 
SELECT
    region,
    rep_name,
    sales_amount
FROM t
WHERE rn = 1
