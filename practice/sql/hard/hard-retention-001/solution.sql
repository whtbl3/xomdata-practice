-- Xom Data · D7 and D30 retention rate
-- Problem: https://xomdata.com/practice/hard-retention-001
-- Solved: 2026-09-14

WITH date_retained AS (
    SELECT
        s.user_id,
        s.signup_date,
        a.active_date,
        MAX(CASE 
            WHEN DATE(a.active_date) BETWEEN DATE(s.signup_date, '+1 day') AND DATE(s.signup_date, '+7 day') THEN 1
            ELSE 0
        END) AS d7_retained,
        MAX(CASE 
            WHEN DATE(a.active_date) BETWEEN DATE(s.signup_date, '+1 day') AND DATE(s.signup_date, '+30 day') THEN 1
            ELSE 0
        END) AS d30_retained
    FROM signups s 
    LEFT JOIN activity a ON s.user_id = a.user_id
    GROUP BY s.user_id
) SELECT
    COUNT(DISTINCT(user_id)) AS total_users,
    COALESCE(SUM(d7_retained), 0) AS d7_retained,
    COALESCE(ROUND(100.0 * COALESCE(SUM(d7_retained), 0) / NULLIF(COUNT(user_id), 0), 2), 0) AS d7_rate,
    COALESCE(SUM(d30_retained), 0) AS d30_retained,
    COALESCE(ROUND(100.0 * COALESCE(SUM(d30_retained), 0) / NULLIF(COUNT(user_id), 0), 2), 0) AS d30_rate
FROM date_retained
