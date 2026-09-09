-- Xom Data · Top 3 products by sales in each category
-- Problem: https://xomdata.com/practice/hard-topn-001
-- Solved: 2026-09-09

WITH ranked AS (
    SELECT 
        category,
        name AS product_name,
        units_sold,
        DENSE_RANK() OVER (PARTITION BY category ORDER BY units_sold DESC) AS rank_in_cat
    FROM products
)
SELECT
    category,
    product_name,
    units_sold,
    rank_in_cat
FROM ranked
WHERE rank_in_cat <= 3
ORDER BY category, rank_in_cat, product_name
