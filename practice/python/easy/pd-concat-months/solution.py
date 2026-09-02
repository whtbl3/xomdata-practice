# Xom Data · Merge two months into one table
# Problem: https://xomdata.com/practice/pd-concat-months
# Solved: 2026-09-02

import pandas as pd


def combine_months(first, second):
    # Stack the two tables and renumber the rows from 0.
    return pd.concat([first, second], axis=0, ignore_index=True)
