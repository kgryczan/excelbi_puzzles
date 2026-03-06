import pandas as pd
import re
import numpy as np

path = "900-999/927/927 Categorization.xlsx"
input = pd.read_excel(path, usecols="A:E", skiprows=1, nrows=25)
test = pd.read_excel(path, usecols="G:I", skiprows=1, nrows=6).rename(columns=lambda c: c.rstrip(".1"))

result = (
    input
    .assign(revenue=lambda d: d.Qty * d.UnitPrice)
    .groupby(["Customer", "Product"], as_index=False)
    .agg(total_revenue=("revenue", "sum"))
    .sort_values(["Customer", "total_revenue"], ascending=[True, False])
    .assign(
        Tier=lambda d: np.select(
            [
                d.total_revenue >= 200000,
                d.total_revenue >= 120000,
                d.total_revenue >= 60000
            ],
            ["Platinum", "Gold", "Silver"],
            default="Bronze"
        )
    )
    .groupby("Customer", as_index=False)
    .head(1)
    .rename(columns={"Product": "Highest Revenue Generating Product"})
    .reset_index(drop=True)
    [["Customer", "Highest Revenue Generating Product", "Tier"]]
)

print(result.equals(test))
# True