-- Xom Data · Monthly recurring revenue (MRR) by subscription plan
-- Problem: https://xomdata.com/practice/hard-mrr-001
-- Solved: 2026-09-28

WITH RECURSIVE 
min_max AS (
    SELECT 
        DATE(MIN(started_at), 'start of month') AS min_month,
        DATE(MAX(started_at), 'start of month') AS max_month
    FROM subscriptions
    WHERE started_at IS NOT NULL
),
months AS (
    SELECT min_month AS month_start FROM min_max WHERE min_month IS NOT NULL
    UNION ALL
    SELECT DATE(month_start, '+1 month')
    FROM months, min_max
    WHERE month_start < min_max.max_month
),
month_analysis AS (
    SELECT 
        STRFTIME('%Y-%m', month_start) AS month,
        DATE(month_start, '+1 month', '-1 day') AS as_of_date
    FROM months
)
SELECT 
    ma.month,
    COUNT(s.user_id) AS active_subs,
    COALESCE(SUM(s.mrr), 0) AS total_mrr
FROM month_analysis ma
LEFT JOIN subscriptions s 
    ON s.started_at <= ma.as_of_date 
   AND (s.ended_at IS NULL OR s.ended_at > ma.as_of_date)
GROUP BY ma.month
ORDER BY ma.month ASC;
