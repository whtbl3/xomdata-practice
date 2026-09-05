-- Xom Data · Basic-plan subscribers
-- Problem: https://xomdata.com/practice/easy-like-001
-- Solved: 2026-09-05

SELECT phone_number, full_name, plans
FROM subscribers
WHERE plans LIKE '%basic%'
ORDER BY full_name;
