-- Xom Data · 4-step onboarding conversion rate
-- Problem: https://xomdata.com/practice/hard-funnel-001
-- Solved: 2026-09-16

WITH step AS (
    SELECT 'signup' AS step, 1 AS step_order
    UNION ALL SELECT 'verify_email', 2
    UNION ALL SELECT 'first_login', 3
    UNION ALL SELECT 'first_purchase', 4
)
SELECT
    s.step,
    COALESCE(COUNT(DISTINCT(e.user_id)), 0) AS n_users,
    COALESCE(ROUND(100.0 * COUNT(DISTINCT e.user_id) / 
    NULLIF((SELECT COUNT(DISTINCT user_id) FROM events WHERE event_name = 'signup'), 0)), 0) AS conversion_pct
FROM step s LEFT JOIN events e
    ON s.step = e.event_name
GROUP BY s.step
ORDER BY step_order
-- SELECT
--     event_name AS step,
--     COUNT(DISTINCT user_id) AS n_users,
--     ROUND(100.0 * COUNT(DISTINCT user_id) / 
--     NULLIF((SELECT COUNT(DISTINCT user_id) FROM events WHERE event_name = 'signup'), 0), 2) AS conversion_pct
-- FROM events
-- GROUP BY event_name
-- ORDER BY
--     CASE 
--         WHEN event_name = 'signup' THEN 1
--         WHEN event_name = 'verify_email' THEN 2
--         WHEN event_name = 'first_login' THEN 3
--         WHEN event_name = 'first_purchase' THEN 4
--         ELSE 5
--     END
