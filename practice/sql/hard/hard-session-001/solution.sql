-- Xom Data · Sessionize logins with a 30-minute gap
-- Problem: https://xomdata.com/practice/hard-session-001
-- Solved: 2026-09-13

WITH event_lag AS (
    SELECT
        id,
        user_id,
        event_at,
        LAG(event_at) OVER (
            PARTITION BY user_id 
            ORDER BY event_at, id
        ) AS prev_event_at
    FROM events
),
marked_events AS (
    SELECT
        *,
        CASE 
            WHEN prev_event_at IS NULL THEN 1
            WHEN CAST(strftime('%s', datetime(event_at)) AS INTEGER)
                 - CAST(strftime('%s', datetime(prev_event_at)) AS INTEGER) >= 30 * 60
            THEN 1 
            ELSE 0
        END AS is_new_session
    FROM event_lag
),
marked_number AS (
    SELECT 
        *,
        SUM(is_new_session) OVER (
            PARTITION BY user_id
            ORDER BY event_at, id
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS session_seq
    FROM marked_events
)
SELECT
    user_id,
    session_seq,
    COUNT(*) AS n_events,
    MIN(event_at) AS session_start,
    MAX(event_at) AS session_end,
    ROUND(
        (CAST(strftime('%s', MAX(event_at)) AS INTEGER) -
         CAST(strftime('%s', MIN(event_at)) AS INTEGER)) / 60.0,
        1
    ) AS duration_min
FROM marked_number
GROUP BY user_id, session_seq
ORDER BY user_id, session_seq;
