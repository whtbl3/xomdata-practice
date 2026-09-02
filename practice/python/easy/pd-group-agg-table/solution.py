# Xom Data · Sales summary table by city
# Problem: https://xomdata.com/practice/pd-group-agg-table
# Solved: 2026-09-02

import pandas as pd


def sales_summary(orders):
    # Return one row per city with columns city, orders, revenue.
    return (orders.groupby('city').agg(
    orders=('order_id', 'count'),
    revenue=('amount', 'sum')
    )
    .sort_index()
    .reset_index()
)
