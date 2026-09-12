-- Xom Data · Retention rate by signup-month cohort
-- Problem: https://xomdata.com/practice/hard-cohort-001
-- Solved: 2026-09-12

WITH cte AS (
    SELECT
        a.user_id,
        strftime('%Y-%m', s.signup_date) AS signup_month,
        strftime('%Y-%m', a.active_date) AS active_month
    FROM signups s JOIN activity a ON s.user_id = a.user_id
)
SELECT
    signup_month,
    active_month,
    COUNT(DISTINCT(user_id)) AS n_active
FROM cte
WHERE active_month >= signup_month
GROUP BY signup_month, active_month
ORDER BY signup_month, active_month
