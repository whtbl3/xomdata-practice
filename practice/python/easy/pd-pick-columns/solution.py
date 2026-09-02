# Xom Data · Trim the table down for a report
# Problem: https://xomdata.com/practice/pd-pick-columns
# Solved: 2026-09-02

import pandas as pd


def pick_columns(table, columns):
    # Return only the listed columns, in the order they are listed.
    return table[columns]
