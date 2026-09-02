# Xom Data · The amount column arrived as text with commas
# Problem: https://xomdata.com/practice/pd-text-to-number
# Solved: 2026-09-02

import pandas as pd


def amounts_to_number(table, column):
    # Strip the thousands separators, then turn the column into integers.\
    df = table.copy()
    df[column] = df[column].str.replace(',', '')
    df[column] = pd.to_numeric(df[column])
    return df
