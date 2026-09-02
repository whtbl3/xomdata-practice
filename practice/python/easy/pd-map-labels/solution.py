# Xom Data · Turn status codes into words people read
# Problem: https://xomdata.com/practice/pd-map-labels
# Solved: 2026-09-02

import pandas as pd


def label_status(orders, labels):
    # Add a status_label column translated from the status codes.
    orders = orders.copy()
    orders['status_label'] = orders['status'].map(labels)
    return orders
