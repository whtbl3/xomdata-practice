# Xom Data · Average order value per sales channel
# Problem: https://xomdata.com/practice/pd-group-mean-round
# Solved: 2026-09-02

import pandas as pd


def average_order_value(orders):
    # Return the average amount per channel, rounded to 2 decimals.
    return orders.groupby('channel')['amount'].agg('mean').round(2)
