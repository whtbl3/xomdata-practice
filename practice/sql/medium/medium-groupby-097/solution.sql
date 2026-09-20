-- Xom Data · Top 10 most-engaged posts
-- Problem: https://xomdata.com/practice/medium-groupby-097
-- Solved: 2026-09-20

SELECT
    u.full_name,
    p.post_type,
    p.post_date,
    (p.like_count + p.comment_count + p.share_count) AS total_interactions,
    RANK() OVER (ORDER BY (p.like_count + p.comment_count + p.share_count) DESC) AS overall_rank,
    ROW_NUMBER() OVER (PARTITION BY u.id ORDER BY (p.like_count + p.comment_count + p.share_count) DESC) AS rank_in_author,
    ROUND(
        (p.like_count + p.comment_count + p.share_count) * 100.0
        / MAX((p.like_count + p.comment_count + p.share_count)) OVER (),
        2
    ) AS pct_of_top
FROM  users u JOIN posts p ON u.id = p.user_id
