-- Xom Data · Daily revenue including zero-sale days
-- Problem: https://xomdata.com/practice/hard-gapfill-001
-- Solved: 2026-09-13

WITH RECURSIVE date_series AS (
    SELECT
        MIN(date) AS date,
        MAX(date) AS max_date
    FROM daily_revenue

    UNION ALL

    SELECT
        DATE(date, '+1 day'),
        max_date
    FROM date_series
    WHERE date < max_date
)
SELECT
    ds.date,
    COALESCE(SUM(dr.amount), 0) AS revenue
FROM date_series ds LEFT JOIN daily_revenue dr ON ds.date = dr.date
GROUP BY ds.date
ORDER BY ds.date;
