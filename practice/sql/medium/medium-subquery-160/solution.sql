-- Xom Data · Low-activity users
-- Problem: https://xomdata.com/practice/medium-subquery-160
-- Solved: 2026-08-24

WITH user_stats AS (
  SELECT
    u.user_name,
    COUNT(o.id) AS order_count,
    SUM(o.value) AS total_value,
    AVG(o.value) AS avg_order_value,
    AVG(SUM(o.value)) OVER () AS avg_of_all_order
  FROM users u
  LEFT JOIN orders o
    ON u.id = o.user_id
  GROUP BY u.id, u.user_name
),
filtered AS (
  SELECT
    user_name,
    order_count,
    total_value,
    avg_order_value,
    CASE
      WHEN order_count = 0 THEN 'Inactive'
      WHEN total_value < avg_of_all_order THEN 'Low'
      ELSE 'Normal'
    END AS tier
  FROM user_stats
  WHERE order_count = 0 OR total_value < avg_of_all_order
)
SELECT
  user_name,
  order_count,
  total_value,
  avg_order_value,
  tier,
  RANK() OVER (
    ORDER BY
      CASE WHEN order_count = 0 THEN 0 ELSE 1 END,
      total_value
  ) AS activity_rank,
  ROUND(
    PERCENT_RANK() OVER (
      ORDER BY
        CASE WHEN order_count = 0 THEN 0 ELSE 1 END,
        total_value
    ) * 100,
    2
  ) AS pct_above_peers
FROM filtered
ORDER BY activity_rank, user_name;
