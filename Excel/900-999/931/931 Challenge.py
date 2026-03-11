import pandas as pd
import numpy as np

path = "900-999/931/931 Category & Rank.xlsx"

input = pd.read_excel(path, usecols="A:C", header=1, nrows=22)
test = pd.read_excel(path, usecols="E:H", header=1, nrows=22).rename(columns=lambda c: c.rstrip(".1"))

result = (
    input
    .assign(
        tenure_years=lambda df: (pd.Timestamp.today().normalize() - pd.to_datetime(df["Hire Date"])).dt.days / 365
    )
    .assign(**{
        "Tenure Level": lambda df: np.select(
            [df["tenure_years"] < 3, df["tenure_years"] < 6],
            ["Junior", "Mid-Level"],
            default="Senior"
        )
    })
    .assign(
        Rank=lambda df: df.groupby("Department")["tenure_years"]
            .rank(method="dense", ascending=False)
            .astype(int)
    )
    .sort_values(["Department", "tenure_years"], ascending=[True, False])
    [["Employee Name", "Department", "Tenure Level", "Rank"]]
    .reset_index(drop=True)
)

print(result.equals(test))
# True
