-- Xom Data · Cumulative revenue from successful transactions only
-- Problem: https://xomdata.com/practice/hard-conditional-001
-- Solved: 2026-09-16

SELECT
    date,
    status,
    amount,
    SUM(
        CASE WHEN status = 'success' THEN amount ELSE 0 END
    ) OVER (
        ORDER BY date, status, id 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_success_total
FROM transactions
