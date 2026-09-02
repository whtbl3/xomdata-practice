# Xom Data · Payments at or above a minimum
# Problem: https://xomdata.com/practice/pd-filter-threshold
# Solved: 2026-09-02

import pandas as pd


def big_payments(payments: pd.DataFrame, min_amount: float):
    # Return the rows whose amount is at least min_amount.
    # Keep the original row order and row labels.
    return payments[payments['amount'] >= min_amount]
