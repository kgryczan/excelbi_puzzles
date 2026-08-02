from datetime import timedelta
from functools import reduce

import pandas as pd

p = "400-499/414/PQ_Challenge_414.xlsx"
tx = pd.read_excel(p, usecols="A:C", nrows=24)
expected = pd.read_excel(p, usecols="E:J", nrows=12)
expected.columns = [
    "Customer",
    "Cycle",
    "Purchase Date",
    "Last Valid Renewal",
    "Successful Renewals",
    "Expiry Date",
]


def cycles(data):
    def step(state, row):
        rows, cycle = state
        date = row["Transaction Date"]
        if row["Type"] == "Purchase":
            return rows + ([cycle] if cycle else []), {
                "Customer": row["Customer"],
                "Cycle": len(rows) + 1 + bool(cycle),
                "Purchase Date": date,
                "Last Valid Renewal": date,
                "Successful Renewals": 0,
                "Expiry Date": date + timedelta(days=90),
            }
        if cycle and date == cycle["Expiry Date"]:
            cycle = cycle.copy()
            cycle.update(
                {
                    "Last Valid Renewal": date,
                    "Successful Renewals": cycle["Successful Renewals"] + 1,
                    "Expiry Date": date + timedelta(days=90),
                }
            )
        elif cycle and date > cycle["Expiry Date"]:
            return rows + [cycle], None
        return rows, cycle

    rows, cycle = reduce(
        step, data.sort_values("Transaction Date").to_dict("records"), ([], None)
    )
    return pd.DataFrame(rows + ([cycle] if cycle else []))


result = pd.concat(
    (cycles(g) for _, g in tx.groupby("Customer", sort=True)), ignore_index=True
)
print(result[expected.columns].equals(expected))
