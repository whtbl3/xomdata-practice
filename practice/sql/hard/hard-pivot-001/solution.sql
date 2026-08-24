-- Xom Data · Revenue pivoted by product type
-- Problem: https://xomdata.com/practice/hard-pivot-001
-- Solved: 2026-08-24

SELECT 
  substr(sale_date, 1, 7) AS month,
  SUM(CASE WHEN category = 'Electronics' THEN amount ELSE 0 END) AS electronics,
  SUM(CASE WHEN category = 'Clothing' THEN amount ELSE 0 END) AS clothing,
  SUM(CASE WHEN category = 'Food' THEN amount ELSE 0 END) AS 
  food,
  SUM(amount) AS total
FROM sales
GROUP BY substr(sale_date, 1, 7)
ORDER BY month
