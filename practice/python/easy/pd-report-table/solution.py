# Xom Data · Turn the raw table into something you can send
# Problem: https://xomdata.com/practice/pd-report-table
# Solved: 2026-09-02

import pandas as pd


def report_table(raw):
    # Keep city and revenue, rename them, sort by revenue, renumber the rows.
    return (
        raw[['cty', 'rev']]
        .rename(columns={'cty': 'city', 'rev': 'revenue'})
        .sort_values(by=['revenue', 'city'], ascending=[False, True])
        .reset_index(drop=True)
    )
