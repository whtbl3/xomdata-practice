-- Xom Data · Salary by department and title
-- Problem: https://xomdata.com/practice/medium-join-126
-- Solved: 2026-09-30

WITH employee_stats AS (
    SELECT
        d.department_name,
        p.position_name,
        COUNT(e.id) AS employee_count,
        ROUND(AVG(net_salary), 2) AS avg_salary,
        MIN(net_salary) AS min_salary,
        MAX(net_salary) AS max_salary
    FROM departments d
    JOIN employees e ON e.department_id = d.id
    JOIN positions p ON e.position_id = p.id
    JOIN payroll pay ON pay.employee_id = e.id
    GROUP BY d.id, d.department_name, p.position_name
),
employee_summary AS (
    SELECT
        department_name,
        position_name,
        employee_count,
        avg_salary,
        min_salary,
        max_salary,
        max_salary - min_salary AS salary_spread,
        RANK() OVER (PARTITION BY department_name ORDER BY avg_salary DESC) AS rank_in_dept
    FROM employee_stats
) SELECT * FROM employee_summary ORDER BY department_name, rank_in_dept, position_name
