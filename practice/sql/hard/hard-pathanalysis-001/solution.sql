-- Xom Data · Most common 3-step user path
-- Problem: https://xomdata.com/practice/hard-pathanalysis-001
-- Solved: 2026-09-14

WITH indexed_views AS (
    SELECT
        user_id,
        page,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY viewed_at) AS step
    FROM page_views
),
user_paths AS (
    SELECT
        user_id,
        step AS current_step,
        page AS path,
        1 AS depth
    FROM indexed_views

    UNION ALL

    SELECT
        p.user_id,
        i.step AS current_step,
        CONCAT(p.path, ' > ', i.page),
        p.depth + 1
    FROM user_paths p JOIN indexed_views i
        ON p.user_id = i.user_id
        AND i.step = p.current_step + 1
    WHERE p.depth < 3
)
SELECT
    path,
    COUNT(DISTINCT(user_id)) AS n_users
FROM user_paths
WHERE depth = 3
GROUP BY path
ORDER BY n_users DESC, path ASC
LIMIT 10;
