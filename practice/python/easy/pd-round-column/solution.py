# Xom Data · Round a share column before printing the report
# Problem: https://xomdata.com/practice/pd-round-column
# Solved: 2026-09-02

import pandas as pd


def round_column(table, column):
    # Round one column to 2 decimal places, leaving the input table untouched.
    df = table.copy()
    df[column] = df[column].round(2)
    return df
