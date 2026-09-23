-- Xom Data · Instructor teaching load
-- Problem: https://xomdata.com/practice/medium-join-029
-- Solved: 2026-09-23

WITH lecturers_stats AS (
    SELECT
        l.id
        , l.full_name
        , l.academic_degree
        , COUNT(COALESCE(s.id)) AS subjects_taught
    FROM lecturers l
        LEFT JOIN subjects s ON l.id = s.lecturer_id
    GROUP BY l.id
)
SELECT
    full_name
    , academic_degree
    , subjects_taught
    , RANK() OVER (ORDER BY subjects_taught DESC) AS workload_rank
    , SUM(subjects_taught) OVER (
        ORDER BY subjects_taught DESC 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS  cumulative_subjects
FROM lecturers_stats
ORDER BY workload_rank, full_name
