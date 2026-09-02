# Xom Data · Keep only the cities we are watching
# Problem: https://xomdata.com/practice/pd-filter-isin
# Solved: 2026-09-02

import pandas as pd


def only_cities(orders, cities):
    # Keep the rows whose city is in the watch list, in the original row order.
    return orders[orders['city'].isin(cities)]
