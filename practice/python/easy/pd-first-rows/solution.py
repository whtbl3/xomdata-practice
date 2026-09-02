# Xom Data · Peek at the first few rows
# Problem: https://xomdata.com/practice/pd-first-rows
# Solved: 2026-09-02

import pandas as pd


def first_rows(table, n):
    # Return the first n rows, keeping the original row labels./.,mnbvcx
    return table.head(n)
