-- Xom Data · Total payroll by org branch
-- Problem: https://xomdata.com/practice/hard-recursive-001
-- Solved: 2026-09-10

WITH RECURSIVE employee_tree AS (
    -- Anchor member: Mọi nhân viên tự làm gốc cho chính nhánh của mình
    SELECT 
        id AS root_id,
        id AS emp_id,
        salary
    FROM employees

    UNION ALL

    -- Recursive member: Tìm tất cả cấp dưới trực tiếp của những người trong nhánh
    SELECT 
        et.root_id,
        e.id AS emp_id,
        e.salary
    FROM employee_tree et
    JOIN employees e ON e.manager_id = et.emp_id
),
direct_counts AS (
    -- Đếm số cấp dưới TRỰC TIẾP của từng quản lý
    SELECT 
        manager_id,
        COUNT(*) AS direct_reports
    FROM employees
    WHERE manager_id IS NOT NULL
    GROUP BY manager_id
)
SELECT 
    m.id AS manager_id,
    m.name AS manager_name,
    dc.direct_reports,
    COUNT(et.emp_id) AS subtree_size,
    SUM(et.salary) AS subtree_salary
FROM direct_counts dc
JOIN employees m ON m.id = dc.manager_id
JOIN employee_tree et ON et.root_id = m.id
GROUP BY m.id, m.name, dc.direct_reports
ORDER BY subtree_salary DESC, manager_id ASC;
