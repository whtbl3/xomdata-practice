-- Xom Data · Suppliers that deliver late frequently
-- Problem: https://xomdata.com/practice/medium-having-162
-- Solved: 2026-09-22

WITH purchase_stat AS (
    SELECT
        supplier_id,
        COUNT(supplier_id) AS purchase_count,
        SUM(total_value) AS total_purchase_value,
        ROUND(AVG(julianday(actual_receipt) - julianday(expected_receipt)), 2) AS avg_late_days,
        ROUND((100.0 * SUM(CASE WHEN actual_receipt <= expected_receipt THEN 1 ELSE 0 END)) / COUNT(*), 2) AS on_time_rate
    FROM purchase_orders
    GROUP BY supplier_id
    HAVING COUNT(supplier_id) >= 3 AND ROUND(AVG(julianday(actual_receipt) - julianday(expected_receipt)), 2) > 0
),
ranked AS (
    SELECT
        s.supplier_name,
        s.material_type,
        p.purchase_count,
        p.total_purchase_value,
        p.avg_late_days,
        p.on_time_rate,
        RANK() OVER (ORDER BY p.avg_late_days DESC) AS late_rank,
        NTILE(4) OVER (ORDER BY p.avg_late_days DESC) AS risk_tier
    FROM purchase_stat p JOIN suppliers s ON p.supplier_id = s.id
)
SELECT
    supplier_name,
    material_type,
    purchase_count,
    total_purchase_value,
    avg_late_days,
    on_time_rate,
    late_rank,
    risk_tier
FROM ranked
ORDER BY risk_tier, supplier_name
