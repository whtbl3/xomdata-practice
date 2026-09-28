-- Xom Data · Goals and cards by team
-- Problem: https://xomdata.com/practice/medium-join-186
-- Solved: 2026-09-28

WITH team_stats AS (
SELECT 
        t.team_name, 
        t.city, 
        COUNT(DISTINCT p.id) AS player_count, 
        COUNT(DISTINCT g.id) AS total_goals_scored, 
        COUNT(DISTINCT pen.id) AS penalty_count 
    FROM teams t 
    LEFT JOIN players p ON p.team_id = t.id 
    LEFT JOIN goals g ON g.player_id = p.id 
    LEFT JOIN penalties pen ON pen.player_id = p.id 
    GROUP BY t.id, t.team_name, t.city
),
team_summary AS (
    SELECT
        *,
        ROUND(total_goals_scored::NUMERIC / NULLIF(player_count, 0), 2) AS goals_per_player,
        ROUND(penalty_count::NUMERIC / NULLIF(player_count, 0), 2) AS cards_per_player
    FROM team_stats
),
ranked AS (
    SELECT
        *,
        RANK() OVER (ORDER BY total_goals_scored DESC) AS scoring_rank,
        SUM(total_goals_scored) OVER (
            ORDER BY total_goals_scored DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_goals
    FROM team_summary
) 
SELECT
    team_name,
    city,
    player_count,
    total_goals_scored,
    penalty_count,
    goals_per_player,
    cards_per_player,
    scoring_rank,
    cumulative_goals
FROM ranked
ORDER BY scoring_rank ASC, team_name ASC;
