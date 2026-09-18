-- Xom Data · Employees averaging over 5 overtime hours
-- Problem: https://xomdata.com/practice/medium-having-128
-- Solved: 2026-09-18

WITH attendance_stat AS (
    SELECT
        employee_id
        , COALESCE(FLOOR(AVG(work_days)), 0) AS avg_work_days
        , COALESCE(AVG(overtime_hours), 0) AS avg_overtime_hours
        , COALESCE(ROUND(AVG(overtime_hours) / NULLIF(AVG(work_days), 0), 4), 0) AS overtime_intensity
        , RANK() OVER (ORDER BY ROUND(AVG(overtime_hours) / NULLIF(AVG(work_days), 0), 4) DESC) AS intensity_rank
        , NTILE(4) OVER (ORDER BY ROUND(AVG(overtime_hours) / NULLIF(AVG(work_days), 0), 4) DESC) AS workload_quartile
    FROM attendance
    GROUP BY employee_id
),
payroll_stat AS (
    SELECT
        employee_id
        , AVG(net_salary) AS avg_salary
    FROM payroll
    GROUP BY employee_id
) 
SELECT
    e.full_name
    , e.employee_code
    , a.avg_work_days
    , a.avg_overtime_hours
    , p.avg_salary
    , a.overtime_intensity
    , a.intensity_rank
    , a.workload_quartile
FROM employees e 
    JOIN attendance_stat a ON e.id = a.employee_id
    JOIN payroll_stat p ON e.id = p.employee_id
WHERE a.avg_overtime_hours > 5 AND a.avg_work_days >= 18
ORDER BY intensity_rank, e.employee_code
