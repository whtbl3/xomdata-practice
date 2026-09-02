# Xom Data · Revenue per city
# Problem: https://xomdata.com/practice/pd-group-sum
# Solved: 2026-09-02

import pandas as pd


def revenue_by_city(orders):
    # Return the total amount per city, sorted by city name.
    return orders.groupby('city')['amount'].sum()
