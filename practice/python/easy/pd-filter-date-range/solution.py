# Xom Data · Orders within a date range
# Problem: https://xomdata.com/practice/pd-filter-date-range
# Solved: 2026-09-02

import pandas as pd


def orders_between(orders, start, end):
    # Keep the orders dated between start and end, both ends included.
    return orders[orders['order_date'].between(start, end)]
