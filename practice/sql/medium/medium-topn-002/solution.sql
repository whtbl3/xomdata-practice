-- Xom Data · Top three sellers per category
-- Problem: https://xomdata.com/practice/medium-topn-002
-- Solved: 2026-10-21

-- Write your SQL here
WITH t AS (
    SELECT
        category,
        product_name,
        units_sold,
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY units_sold DESC, product_name) AS rn
    FROM menu_sales
)
SELECT
    category,
    product_name,
    units_sold
FROM t
WHERE rn <= 3
ORDER BY category, units_sold DESC, product_name
