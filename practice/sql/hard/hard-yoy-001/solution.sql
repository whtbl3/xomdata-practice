-- Xom Data · YoY and QoQ sales growth
-- Problem: https://xomdata.com/practice/hard-yoy-001
-- Solved: 2026-09-11

WITH
  t1 AS (
    SELECT
      YEAR,
      quarter,
      revenue,
      LAG(revenue) OVER (
        ORDER BY
          YEAR,
          quarter
      ) AS prev_quarter_revenue,
      LAG(revenue, 4) OVER (
        ORDER BY
          YEAR,
          quarter
      ) AS prev_year_revenue
    FROM
      quarterly_sales
  )
SELECT
  YEAR,
  quarter,
  revenue,
  prev_quarter_revenue,
  prev_year_revenue,
  ROUND(100.0 * (revenue - prev_quarter_revenue) / NULLIF(prev_quarter_revenue, 0), 2) AS qoq_pct,
  ROUND(100.0 * (revenue - prev_year_revenue) / NULLIF(prev_year_revenue, 0), 2) AS yoy_pct
FROM
  t1
ORDER BY
  year,
  quarter;
