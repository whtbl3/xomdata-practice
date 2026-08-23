-- Xom Data · Employees paid above their department average
-- Problem: https://xomdata.com/practice/medium-subquery-110
-- Solved: 2026-08-23

with dept_avg as (
  select
    department_id,
    round(avg(salary), 0) as dept_avg_salary
  from employees
  group by department_id
)
select
  e.full_name,
  d.dept_name,
  e.salary,
  da.dept_avg_salary,
  round(((e.salary - da.dept_avg_salary) * 100) / da.dept_avg_salary, 2) as premium_pct
from employees e
  inner join departments d on e.department_id = d.id
  inner join dept_avg da on e.department_id = da.department_id
where e.salary > da.dept_avg_salary
ORDER BY premium_pct DESC, d.dept_name ASC, e.full_name ASC;
