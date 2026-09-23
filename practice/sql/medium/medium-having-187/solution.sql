-- Xom Data · Players with 3 or more goals
-- Problem: https://xomdata.com/practice/medium-having-187
-- Solved: 2026-09-23

WITH stats_goals AS (
    SELECT
        player_id
        , COUNT(id) AS goal_count
        , COUNT(DISTINCT match_id) AS scoring_matches
    FROM goals
    GROUP BY player_id 
),
stats_cards AS (
    SELECT
        player_id
        , COUNT(id) AS cards_received
    FROM penalties
    GROUP BY player_id
),
player_summary AS (
    SELECT
        p.full_name
        , p.positions
        , t.team_name
        , sg.goal_count
        , sg.scoring_matches
        , COALESCE(sc.cards_received, 0) AS cards_received
        , ROUND(sg.goal_count::numeric / sg.scoring_matches, 2) AS goals_per_match
    FROM players p
        LEFT JOIN teams t ON p.team_id = t.id
        LEFT JOIN stats_goals sg ON p.id = sg.player_id
        LEFT JOIN stats_cards sc ON p.id = sc.player_id
    WHERE sg.goal_count >=3 AND COALESCE(sc.cards_received, 0) < 5 
)
SELECT
    full_name
    ,positions
    ,team_name
    ,goal_count
    ,scoring_matches
    ,cards_received
    ,goals_per_match
    ,DENSE_RANK() OVER (ORDER BY goals_per_match DESC) AS efficiency_rank
    ,RANK() OVER (ORDER BY goal_count DESC) AS volume_rank
FROM player_summary
ORDER BY efficiency_rank, full_name
