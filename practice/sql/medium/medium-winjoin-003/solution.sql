-- Xom Data · Each aisle's best seller
-- Problem: https://xomdata.com/practice/medium-winjoin-003
-- Solved: 2026-09-29

-- Write your SQL here
WITH product_summary AS (
    SELECT
        c.id AS category_id,
        c.category_name,
        p.id AS product_id,
        p.product_name,
        SUM(p.units_sold) AS total_sold
    FROM categories c JOIN products p ON c.id = p.category_id
    GROUP BY c.id, c.category_name, p.id, p.product_name
),
ranked AS (
    SELECT
        category_name,
        product_name,
        total_sold AS units_sold,
        ROW_NUMBER() OVER (
            PARTITION BY category_id 
            ORDER BY total_sold DESC, product_name ASC) AS rn
    FROM product_summary
)
SELECT
    category_name,
    product_name,
    units_sold
FROM ranked WHERE rn = 1
ORDER BY category_name ASC
