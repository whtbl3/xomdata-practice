# Xom Data · Large orders from one sales channel
# Problem: https://xomdata.com/practice/pd-filter-two-conditions
# Solved: 2026-09-02

import pandas as pd


def channel_orders(orders: pd.DataFrame, channel: str, min_amount: float):
    # Return the rows of the given channel whose amount is at least min_amount.
    return orders[(orders['channel'] == channel) & (orders['amount'] >= min_amount)]
