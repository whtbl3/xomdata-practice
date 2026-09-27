-- Xom Data · Kênh nào tạo ra khách trung thành
-- Problem: https://xomdata.com/practice/medium-repeat-005
-- Solved: 2026-09-27

WITH customers_summary AS (
    SELECT
        c.channel,
        c.customer_id,
        COUNT(d.order_id) AS total_orders
    FROM customers c
    JOIN orders d ON c.customer_id = d.customer_id
    GROUP BY c.channel, c.customer_id
    ORDER BY c.customer_id
),
channels_stats AS (
    SELECT
        channel,
        COUNT(customer_id) AS customers,
        COUNT(CASE WHEN total_orders >= 3 THEN customer_id END) AS loyal_customers
    FROM customers_summary
    GROUP BY channel
)
SELECT
    channel,
    customers,
    loyal_customers,
    ROUND((loyal_customers::numeric / customers) * 100, 2) AS loyal_rate_pct
FROM channels_stats
ORDER BY loyal_rate_pct DESC, channel ASC
