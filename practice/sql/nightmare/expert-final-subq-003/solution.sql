-- Xom Data · Second-highest-paid employee per department
-- Problem: https://xomdata.com/practice/expert-final-subq-003
-- Solved: 2026-09-21

WITH department_salary AS (
    SELECT
        id,
        full_name,
        department,
        salary,
        DENSE_RANK() OVER (
            PARTITION BY department
            ORDER BY salary DESC
        ) AS ranked_salary
    FROM employees
) 
SELECT
    department,
    full_name,
    salary
FROM department_salary
WHERE ranked_salary = 2
ORDER BY department, full_name
