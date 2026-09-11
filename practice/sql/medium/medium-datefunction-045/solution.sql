-- Xom Data · Transaction count and amount by month
-- Problem: https://xomdata.com/practice/medium-datefunction-045
-- Solved: 2026-09-11

WITH cte AS (
    SELECT
        strftime('%Y-%m', transaction_date) AS month,
        COUNT(*) AS transaction_count,
        SUM(amount) AS total_amount,
        LAG(SUM(amount)) OVER (ORDER BY strftime('%Y-%m', transaction_date)) AS lag_total_amount
    FROM transactions
    GROUP BY month
)
SELECT
    month,
    transaction_count,
    total_amount,
    total_amount - lag_total_amount AS mom_delta
FROM cte
