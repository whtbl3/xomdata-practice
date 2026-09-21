-- Xom Data · Monthly income and expense report
-- Problem: https://xomdata.com/practice/medium-groupby-080
-- Solved: 2026-09-21

WITH stat AS (
    SELECT
        strftime('%Y-%m', transaction_date) AS month,
        SUM(
            CASE 
                WHEN type = 'Income' THEN amount 
                ELSE 0 
            END
        ) AS total_income,
        SUM(
            CASE 
                WHEN type = 'Expense' THEN amount 
                ELSE 0 
            END
        ) AS total_expense,
        SUM(
            CASE 
                WHEN type = 'Income' THEN amount
                WHEN type = 'Expense' THEN -amount
            END
        ) AS balance,
        SUM(
            SUM(
                CASE 
                    WHEN type = 'Income' THEN amount
                    WHEN type = 'Expense' THEN -amount
                END
            )
        ) OVER (ORDER BY strftime('%Y-%m', transaction_date)) AS cumulative_balance
    FROM transactions
    GROUP BY month
)
SELECT
    month,
    total_income,
    total_expense,
    balance,
    cumulative_balance,
    CASE 
        WHEN total_income > total_expense THEN 'Surplus'
        WHEN total_income < total_expense THEN 'Deficit'
        WHEN total_income = total_expense THEN 'Balanced'
    END AS status
FROM stat
ORDER BY month
