-- Xom Data · Classify products by sales velocity
-- Problem: https://xomdata.com/practice/medium-case-110
-- Solved: 2026-09-17

WITH prod_stats AS (
    SELECT
        product_id,
        SUM(quantity) AS total_sold,
        CASE
            WHEN SUM(quantity) >= 100 THEN 'Best Seller'
            WHEN SUM(quantity) >= 50 THEN 'Average'
            ELSE 'Slow Mover'
        END AS classification
    FROM transactions
    GROUP BY product_id
),
cat_sum AS (
    SELECT
        p.name,
        p.categories,
        s.total_sold,
        s.classification,
        DENSE_RANK() OVER (PARTITION BY p.categories ORDER BY s.total_sold DESC) AS rank_in_cat,
        SUM(total_sold) OVER (PARTITION BY categories) AS cat_total
    FROM prod_stats s JOIN products p ON s.product_id = p.id
)
SELECT
    name,
    categories,
    total_sold,
    classification,
    rank_in_cat,
    ROUND((total_sold * 1.0 / cat_total) * 100, 2) AS pct_of_cat_total
FROM cat_sum
ORDER BY categories, rank_in_cat, name
