-- Xom Data · Top 10 highest-paid employees and their leave days
-- Problem: https://xomdata.com/practice/medium-agg-127
-- Solved: 2026-09-13

WITH emp_salary AS (
    SELECT
        employee_id,
        SUM(net_salary) AS total_received_salary
    FROM payroll
    GROUP BY employee_id
),
emp_leaves AS (
    SELECT
        employee_id,
        COUNT(*) AS leave_count
    FROM leaves
    WHERE status = 'approved'
    GROUP BY employee_id
),
emp_stats AS (
    SELECT
        e.full_name,
        e.employee_code,
        d.department_name,
        COALESCE(es.total_received_salary, 0) AS total_received_salary,
        COALESCE(el.leave_count, 0) AS leave_count,
        AVG(COALESCE(es.total_received_salary, 0)) OVER (
            PARTITION BY e.department_id
        ) AS dept_avg_salary
    FROM employees e
    LEFT JOIN departments d ON e.department_id = d.id
    LEFT JOIN emp_salary es ON es.employee_id = e.id
    LEFT JOIN emp_leaves el ON el.employee_id = e.id
)
SELECT
    full_name,
    employee_code,
    department_name,
    total_received_salary,
    leave_count,
    ROUND(
        100.0 * (total_received_salary - dept_avg_salary)
        / NULLIF(dept_avg_salary, 0),
        2
    ) AS pct_above_dept_avg
FROM emp_stats
ORDER BY total_received_salary DESC, employee_code ASC
LIMIT 10;
