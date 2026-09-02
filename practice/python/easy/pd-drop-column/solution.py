# Xom Data · Remove a column that must not leave the company
# Problem: https://xomdata.com/practice/pd-drop-column
# Solved: 2026-09-02

import pandas as pd


def drop_column(table, column):
    # Return the table without the given column; do nothing if it is absent.
    return table.drop(columns=column, errors='ignore')
