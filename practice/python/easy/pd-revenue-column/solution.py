# Xom Data · Add the line total to each order
# Problem: https://xomdata.com/practice/pd-revenue-column
# Solved: 2026-09-02

import pandas as pd


def add_revenue(orders):
    # Return a copy with a revenue column; leave the input table untouched.
    orders = orders.copy()
    orders['revenue'] = orders['quantity'] * orders['unit_price']
    return orders
