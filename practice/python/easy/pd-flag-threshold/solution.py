# Xom Data · Flag the customers who spent a lot this year
# Problem: https://xomdata.com/practice/pd-flag-threshold
# Solved: 2026-09-02

import pandas as pd
import numpy as np


def flag_big_spenders(customers, threshold):
    # Add a tier column: "VIP" at or above the threshold, "Regular" below it.
    df = customers.copy()
    df['tier'] = np.where(df['spend']>=threshold, "VIP", "Regular")
    return df
