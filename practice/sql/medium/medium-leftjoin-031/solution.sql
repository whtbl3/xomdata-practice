-- Xom Data · Candidates not yet interviewed
-- Problem: https://xomdata.com/practice/medium-leftjoin-031
-- Solved: 2026-09-07

SELECT 
    full_name, 
    email, 
    application_date,
    ROW_NUMBER() OVER (ORDER BY application_date) AS queue_position,
    ROUND(PERCENT_RANK() OVER (ORDER BY application_date) * 100, 2) AS older_than_pct
FROM candidates
WHERE id NOT IN (
    SELECT candidate_id
    FROM interviews
)
ORDER BY queue_position ASC
