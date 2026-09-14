-- Xom Data · Total sales by org branch
-- Problem: https://xomdata.com/practice/hard-hierarchical-001
-- Solved: 2026-09-14

WITH RECURSIVE emp_tree AS (
    SELECT
        id AS root_id
      , id AS employee_id
      , name
    FROM agents

    UNION ALL

    SELECT
        t.root_id
      , a.id AS employee_id
      , t.name
    FROM agents a JOIN emp_tree t ON a.manager_id = t.employee_id
)
SELECT
    t.root_id AS agent_id,
    -- t.employee_id,
    t.name AS agent_name,
    a.direct_sales,
    SUM(a.direct_sales) AS team_total
FROM emp_tree t JOIN agents a ON t.employee_id = a.id
GROUP BY root_id
ORDER BY team_total DESC, agent_id
