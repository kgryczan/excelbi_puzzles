import numpy as np
import pandas as pd

path = "400-499/415/PQ_Challenge_415.xlsx"

input = pd.read_excel(path, usecols="A", skiprows=1, header=None)[0]
test = pd.read_excel(path, usecols="C:F", nrows=8)

data = input.str.split(",", expand=True)
data.columns = data.iloc[0]
data = data.iloc[1:]

long = data.melt(["ID", "Category"], var_name="Metric")
long[["Type", "Year"]] = long["Metric"].str.extract(r"(Plan|Actual) (\d{4})")
long["value"] = pd.to_numeric(long["value"])

result = (
    long.groupby(["Category", "Year", "Type"])["value"]
    .sum()
    .unstack()
    .reset_index()
    .sort_values(["Category", "Year"])
)

result["Qtr-Yr"] = np.where(result["Year"] == "2023", "Q1-2023", "Q2-2024")

result.loc[result["Category"].duplicated(), "Category"] = np.nan

result = result[["Category", "Qtr-Yr", "Actual", "Plan"]].astype(test.dtypes.to_dict())

print(result.equals(test))
