-- Xom Data · Detect anomalous days vs the average
-- Problem: https://xomdata.com/practice/hard-anomaly-001
-- Solved: 2026-09-14

WITH stats AS (
    SELECT 
        AVG(1.0 * value) AS avg_val,
        SQRT(AVG((1.0 * value - (SELECT AVG(1.0 * value) FROM daily_metrics)) * (1.0 * value - (SELECT AVG(1.0 * value) FROM daily_metrics)))) AS std_val
    FROM daily_metrics
)
SELECT 
    d.date,
    d.value,
    ROUND(s.avg_val, 2) AS mean,
    ROUND(s.std_val, 2) AS stddev,
    CASE 
        WHEN s.std_val = 0 THEN 0.00
        ELSE ROUND((d.value - s.avg_val) / s.std_val, 2)
    END AS z_score,
    CASE 
        WHEN s.std_val = 0 THEN 'normal'
        WHEN (d.value - s.avg_val) / s.std_val > 2 THEN 'high'
        WHEN (d.value - s.avg_val) / s.std_val < -2 THEN 'low'
        ELSE 'normal'
    END AS flag
FROM daily_metrics d
CROSS JOIN stats s
ORDER BY d.date ASC;
