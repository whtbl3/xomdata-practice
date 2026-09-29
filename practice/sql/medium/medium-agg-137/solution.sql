-- Xom Data · Investor trade summary
-- Problem: https://xomdata.com/practice/medium-agg-137
-- Solved: 2026-09-29

-- Summarize buy/sell totals per investor
WITH trade_base AS (
  SELECT
    investor_id,
    COUNT(investor_id) AS total_trades,
    COALESCE(SUM(amount) FILTER(WHERE side = 'buy'), 0) AS total_bought,
    COALESCE(SUM(amount) FILTER(WHERE side = 'sell'), 0) AS total_sold
  FROM trades
  GROUP BY investor_id
),
trade_stat AS (
  SELECT
    investor_id,
    total_trades,
    total_bought,
    total_sold,
    total_bought - total_sold AS net_position,
    total_bought + total_sold AS total_amount,
    CASE
      WHEN total_bought > total_sold THEN 'Bull'
      WHEN total_bought < total_sold THEN 'Bear'
      ELSE 'Neutral'
    END AS stance
  FROM trade_base
)
SELECT  
  i.full_name,
  i.segment,
  s.total_trades,
  s.total_bought,
  s.total_sold,
  s.net_position,
  s.stance,
  DENSE_RANK() OVER (
    PARTITION BY i.segment
    ORDER BY total_amount DESC
  ) AS rank_in_segment
FROM investors i JOIN trade_stat s ON i.id = s.investor_id
ORDER BY s.total_amount DESC, i.full_name
