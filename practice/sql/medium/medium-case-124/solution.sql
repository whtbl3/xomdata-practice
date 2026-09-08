-- Xom Data · Classify student academic performance
-- Problem: https://xomdata.com/practice/medium-case-124
-- Solved: 2026-09-08

WITH avg_std AS (
    SELECT
        std.full_name,
        std.student_code,
        ROUND(AVG(scr.final_score), 2) AS avg_score
    FROM students std INNER JOIN scores scr ON std.id = scr.student_id
    GROUP BY std.id, std.full_name, std.student_code
    ORDER BY avg_score DESC
    LIMIT 20
)
SELECT
    full_name,
    student_code,
    avg_score,
    CASE 
        WHEN avg_score >= 9 THEN 'Excellent'
        WHEN avg_score >= 8 THEN 'Good'
        WHEN avg_score >= 7 THEN 'Fair'
        WHEN avg_score >= 5 THEN 'Average'
        ELSE 'Poor'
    END AS grade,
    DENSE_RANK() OVER (ORDER BY avg_score DESC, full_name) AS class_rank
FROM avg_std
