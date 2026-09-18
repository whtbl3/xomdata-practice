-- Xom Data · Delivery performance by size class
-- Problem: https://xomdata.com/practice/medium-case-160
-- Solved: 2026-09-18

WITH trucks_info AS (
    SELECT
        id,
        vehicle_type,
        capacity_tons,
        CASE
            WHEN capacity_tons >= 10 THEN 'Large Truck'
            WHEN capacity_tons >= 5 THEN 'Medium Truck'
            ELSE 'Small Truck'
        END AS size_class
    FROM trucks
),
shipments_stat AS (
    SELECT 
        truck_id,
        COUNT(*) AS shipment_count
    FROM shipments
    GROUP BY truck_id
),
delivers_stat AS (
    SELECT
        s.truck_id,
        ss.shipment_count,
        SUM(
            CASE
                WHEN results = 'success' THEN 1 ELSE 0
            END
        ) AS  delivered,
        ROUND (
            (SUM(CASE WHEN results = 'success' THEN 1 ELSE 0 END) * 1.0 / ss.shipment_count) * 100.0
        , 2) AS delivery_rate
    FROM deliveries d 
        JOIN shipments s ON d.shipment_id = s.id
        JOIN shipments_stat ss ON ss.truck_id = s.truck_id
    GROUP BY s.truck_id, ss.shipment_count
)
SELECT
    ti.vehicle_type,
    ti.capacity_tons,
    ds.shipment_count,
    ti.size_class,
    ds.delivered,
    ds.delivery_rate,
    RANK() OVER (PARTITION BY ti.size_class ORDER BY ds.delivery_rate DESC) AS rank_in_size
FROM trucks_info ti JOIN delivers_stat ds on ti.id = ds.truck_id
ORDER BY  ti.size_class, rank_in_size, ti.vehicle_type
