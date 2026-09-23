-- Xom Data · Stock-in history by supplier
-- Problem: https://xomdata.com/practice/medium-join-014
-- Solved: 2026-09-23

WITH warehouse_stats AS (
    SELECT
        warehouse_id 
        , COUNT(*) AS import_count
        , COUNT(DISTINCT product_id) AS distinct_product_count
        , COUNT(DISTINCT suppliers) AS distinct_supplier_count
        , MAX(import_date) AS last_import_date
    FROM stock_imports
    GROUP BY warehouse_id 
),
warehouse_summary AS (
    SELECT
        w.warehouse_name
        , s.import_count
        , s.distinct_product_count
        , s.distinct_supplier_count
        , s.last_import_date
        , RANK() OVER (
            ORDER BY s.import_count DESC
        ) AS activity_rank
    FROM warehouses w 
        JOIN warehouse_stats s ON w.id = s.warehouse_id
)
SELECT
    warehouse_name
    , import_count
    , distinct_product_count
    , distinct_supplier_count
    , last_import_date
    , activity_rank
    , LAG(warehouse_name) OVER (ORDER BY activity_rank) AS prev_warehouse
FROM warehouse_summary
ORDER BY activity_rank, warehouse_name
