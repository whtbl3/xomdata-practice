-- Xom Data · Median and percentile salary by department
-- Problem: https://xomdata.com/practice/hard-percentile-001
-- Solved: 2026-09-10

WITH ranked_employees AS (
    SELECT 
        department,
        salary,
        PERCENT_RANK() OVER (
            PARTITION BY department 
            ORDER BY salary ASC
        ) AS pct_rank
    FROM employees
),
calc_distances AS (
    SELECT 
        department,
        salary,
        pct_rank,
        ABS(pct_rank - 0.25) AS diff_p25,
        ABS(pct_rank - 0.50) AS diff_p50,
        ABS(pct_rank - 0.75) AS diff_p75
    FROM ranked_employees
),
best_p25 AS (
    SELECT DISTINCT ON (department) department, salary AS p25
    FROM calc_distances
    ORDER BY department, diff_p25 ASC, salary ASC
),
best_p50 AS (
    SELECT DISTINCT ON (department) department, salary AS p50
    FROM calc_distances
    ORDER BY department, diff_p50 ASC, salary ASC
),
best_p75 AS (
    SELECT DISTINCT ON (department) department, salary AS p75
    FROM calc_distances
    ORDER BY department, diff_p75 ASC, salary ASC
)
SELECT 
    p25.department,
    p25.p25,
    p50.p50,
    p75.p75
FROM best_p25 p25
JOIN best_p50 p50 ON p25.department = p50.department
JOIN best_p75 p75 ON p25.department = p75.department
ORDER BY p25.department ASC;
