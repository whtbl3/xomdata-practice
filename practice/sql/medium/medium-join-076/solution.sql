-- Xom Data · Showtime count and average ticket price per film
-- Problem: https://xomdata.com/practice/medium-join-076
-- Solved: 2026-09-19

WITH showtime_stat AS (
    SELECT
        s.movie_id,
        m.movie_name,
        m.genres,
        COUNT(s.movie_id) AS showtime_count,
        AVG(s.ticket_price) AS avg_ticket_price,
        DENSE_RANK() OVER (PARTITION BY m.genres ORDER BY AVG(s.ticket_price) DESC) AS rank_in_genre,
        FIRST_VALUE(m.movie_name) OVER (
            PARTITION BY m.genres 
            ORDER BY AVG(s.ticket_price) DESC, m.movie_name
        ) AS top_movie_in_genre
    FROM movies m JOIN showtimes s ON m.id = s.movie_id
    GROUP BY s.movie_id, m.genres
)
SELECT
    movie_name,
    genres,
    showtime_count,
    avg_ticket_price,
    rank_in_genre,
    top_movie_in_genre
FROM showtime_stat
ORDER BY genres, rank_in_genre, movie_name
