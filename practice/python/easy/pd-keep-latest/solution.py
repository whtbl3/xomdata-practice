# Xom Data · Keep the latest status of each order
# Problem: https://xomdata.com/practice/pd-keep-latest
# Solved: 2026-09-02

import pandas as pd


def keep_latest(events, key):
    # Keep only the last row for each value of the key column.
    return events.drop_duplicates(subset=[key], keep='last')
