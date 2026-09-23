-- Xom Data · Students above the subject average
-- Problem: https://xomdata.com/practice/medium-subquery-028
-- Solved: 2026-09-23

WITH subject_stats AS (
    SELECT
        subject_id,
        ROUND(AVG(COALESCE(final_score, 0)), 2) AS subject_avg
    FROM grades
    GROUP BY subject_id
),
student_summary AS (
    SELECT
        std.full_name,
        sub.subject_name,
        g.final_score,
        ss.subject_avg,
        ROUND(g.final_score - ss.subject_avg, 2) AS diff_from_avg
    FROM students std
        JOIN grades g ON std.id = g.student_id
        JOIN subjects sub ON sub.id = g.subject_id
        JOIN subject_stats ss ON g.subject_id = ss.subject_id
    WHERE g.final_score > ss.subject_avg
)
SELECT
    full_name,
    subject_name,
    final_score,
    subject_avg,
    diff_from_avg
FROM student_summary
ORDER BY diff_from_avg DESC, subject_name ASC, full_name ASC
