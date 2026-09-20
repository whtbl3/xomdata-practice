-- Xom Data · Thứ bậc chi tiêu trong nội bộ mỗi kênh
-- Problem: https://xomdata.com/practice/medium-classify-002
-- Solved: 2026-09-20

SELECT
    c.channel,
    c.customer_id,
    SUM(COALESCE(o.amount, 0)) AS total_spent,
    DENSE_RANK() OVER (PARTITION BY c.channel ORDER BY SUM(COALESCE(o.amount, 0)) DESC) AS rank_in_channel
FROM customers c LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY c.channel, rank_in_channel, c.customer_id
