# Xom Data · The city that brought in the most
# Problem: https://xomdata.com/practice/pd-top-group
# Solved: 2026-09-02

import pandas as pd


def best_city(orders):
    # Return the name of the city with the highest total amount.
    return orders.groupby('city')['amount'].agg('sum').reset_index().sort_values(by=['amount', 'city'], ascending=[False, True]).iloc[0, 0]
