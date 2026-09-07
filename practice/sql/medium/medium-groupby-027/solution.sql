-- Xom Data · Average score per subject
-- Problem: https://xomdata.com/practice/medium-groupby-027
-- Solved: 2026-09-07

WITH agg AS (
    SELECT
        s.subject_name,
        s.credits,
        COUNT(g.subject_id) AS student_count,
        COALESCE(ROUND(AVG(g.final_score), 2), 0) AS avg_score,
        COALESCE(ROUND(
            SUM(CASE WHEN g.final_score >= 5 THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(g.id), 0),
        2), 0) AS pass_rate
    FROM subjects s LEFT JOIN grades g ON s.id = g.subject_id
    GROUP BY s.subject_name, s.credits
) 
SELECT
    subject_name,
    credits,
    student_count,
    avg_score,
    pass_rate,
    RANK() OVER (ORDER BY avg_score DESC) AS rank_by_avg,
    NTILE(4) OVER (ORDER BY avg_score DESC, subject_name ASC) AS difficulty_quartile
FROM agg
ORDER BY rank_by_avg, subject_name
