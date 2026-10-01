-- Xom Data · This invoice's share of the client's spend
-- Problem: https://xomdata.com/practice/medium-winjoin-005
-- Solved: 2026-10-01

-- Write your SQL here
WITH invoices_stats AS (
    SELECT
        client_id,
        invoice_code,
        amount,
        SUM(amount) OVER (PARTITION BY client_id) AS total_amount
    FROM invoices
)
SELECT
    c.client_name,
    s.invoice_code,
    s.amount,
    ROUND(s.amount * 100.0 / NULLIF(total_amount, 0), 2) AS pct_of_client
FROM clients c
JOIN invoices_stats s ON c.id = s.client_id
ORDER BY c.client_name ASC, pct_of_client DESC, s.invoice_code ASC
