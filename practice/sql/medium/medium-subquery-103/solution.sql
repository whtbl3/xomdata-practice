-- Xom Data · Products more expensive than the category average
-- Problem: https://xomdata.com/practice/medium-subquery-103
-- Solved: 2026-08-23

WITH
  avg_prod AS (
    SELECT
      product_name,
      category,
      price,
      avg(price) OVER (
        PARTITION BY
          category
      ) AS avg_product
    FROM
      products
  ),
diff_avg AS (
  SELECT  product_name,
    category,
    price,
    avg_product,
    price - avg_product as diff_from_avg
FROM avg_prod
)
SELECT
  product_name,
  category,
  price,
  diff_from_avg,
  round((diff_from_avg / nullif(avg_product, 0) * 100), 2) as pct_above
from diff_avg
where price > avg_product
ORDER BY pct_above DESC, product_name ASC;
