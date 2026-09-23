-- Xom Data · Rank hotels by room price within each destination
-- Problem: https://xomdata.com/practice/medium-join-155
-- Solved: 2026-09-23

WITH hostels_stats AS (
    SELECT
        d.id,
        h.hotel_name,
        h.star_class,
        d.destination_name,
        COUNT(*) AS room_count,
        MIN(r.nightly_rate) AS min_price,
        MAX(r.nightly_rate) AS max_price,
        ROUND(AVG(COALESCE(r.nightly_rate, 0)), 2) AS avg_price,
        MAX(r.nightly_rate) - MIN(r.nightly_rate) AS price_spread
    FROM hotel_rooms r
        JOIN hotels h ON h.id = r.hotel_id
        JOIN destinations d ON d.id = h.destination_id
    GROUP BY h.id, d.id
    HAVING COUNT(*) >= 2
), 
ranked AS (
    SELECT 
        *,
        RANK() OVER (PARTITION BY id ORDER BY avg_price DESC) AS rank_in_destination
    FROM hostels_stats
)
SELECT 
    hotel_name,
    star_class,
    destination_name,
    room_count,
    min_price,
    max_price,
    avg_price,
    price_spread,
    rank_in_destination
FROM ranked
ORDER BY 
    destination_name ASC,
    rank_in_destination ASC,
    hotel_name ASC;
