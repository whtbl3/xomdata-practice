-- Xom Data · Top 10 most-borrowed books
-- Problem: https://xomdata.com/practice/medium-subquery-198
-- Solved: 2026-09-25

WITH loans_stats AS (
    SELECT
        book_id,
        COUNT(*) AS borrow_count
    FROM book_loans
    GROUP BY book_id
    ORDER BY borrow_count DESC
),
reserv_stats AS (
    SELECT
        book_id,
        COUNT(*) AS pending_reservation
    FROM reservations
    WHERE status = 'ready_pickup'
    GROUP BY book_id
),
book_summary AS (
    SELECT
        b.title,
        a.full_name AS authors,
        p.publisher_name,
        g.genre_name,
        COALESCE(ls.borrow_count, 0) AS borrow_count,
        COALESCE(rs.pending_reservation, 0) AS pending_reservation,
        (COALESCE(ls.borrow_count, 0) + COALESCE(rs.pending_reservation, 0)) AS engagement
    FROM books b LEFT JOIN authors a ON b.author_id = a.id
    LEFT JOIN publishers p ON b.publisher_id = p.id
    LEFT JOIN genres g ON b.genre_id = g.id
    LEFT JOIN loans_stats ls ON b.id = ls.book_id
    LEFT JOIN reserv_stats rs ON b.id = rs.book_id
)
SELECT
    *,
    DENSE_RANK() OVER (ORDER BY engagement DESC) AS overall_rank,
    RANK() OVER (
        PARTITION BY genre_name
        ORDER BY engagement DESC
    ) AS rank_in_genre
FROM book_summary
ORDER BY overall_rank, title
LIMIT 10
