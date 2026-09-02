# Xom Data · Fill the blanks of one column with a default
# Problem: https://xomdata.com/practice/pd-fill-missing
# Solved: 2026-09-02

import pandas as pd


def fill_missing(table, column, value):
    # Fill the empty cells of one column, leaving the input table untouched.
    df = table.copy()
    df[column] = df[column].fillna(value)
    return df
