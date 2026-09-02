# Xom Data · How many rows and columns did we get
# Problem: https://xomdata.com/practice/pd-table-size
# Solved: 2026-09-02

import pandas as pd


def table_size(table):
    # Return (number of rows, number of columns).
    return table.shape
