-- Xom Data · Top 2 salespeople by sales each month
-- Problem: https://xomdata.com/practice/expert-final-multi-007
-- Solved: 2026-09-21

WITH monthly_revenue AS (
    SELECT
        employee_id,
        month,
        SUM(revenue) AS total_sales
    FROM sales
    GROUP BY employee_id, month
    ORDER BY month, employee_id
),
ranked AS (
    SELECT
        r.month,
        DENSE_RANK() OVER (
            PARTITION BY month
            ORDER BY r.total_sales DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS sales_rank,
        r.employee_id,
        e.full_name,
        r.total_sales
    FROM employees e JOIN monthly_revenue r ON e.id = r.employee_id
)
SELECT
    month,
    sales_rank,
    employee_id,
    full_name,
    total_sales
FROM ranked
WHERE sales_rank <= 2
ORDER BY month, sales_rank, employee_id
