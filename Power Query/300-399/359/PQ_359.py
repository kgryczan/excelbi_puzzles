import pandas as pd
import numpy as np

path = "Power Query/300-399/359/PQ_Challenge_359.xlsx"
input = pd.read_excel(path, usecols=[0], skiprows=1, nrows=51, header=None, names=['Data'])
test = pd.read_excel(path, usecols="C:F", nrows=12)

df = input["Data"].str.split(",", expand=True)
df.columns = ["Date","Category","Cust_ID","Amount"]
df = df.apply(lambda x: x.str.strip() if x.dtype == "object" else x)
df = df[df["Date"] != "Date"].reset_index(drop=True)
df["Date"] = pd.to_datetime(df["Date"])
df["Month"] = df["Date"].dt.to_period("M").dt.to_timestamp()
base = df[["Month","Category","Cust_ID"]].drop_duplicates().sort_values(["Cust_ID","Month"])
g = base.groupby(["Cust_ID","Category"])["Month"]
base["ok"] = (base["Month"] == g.shift(1) + pd.offsets.MonthBegin(1)) & (g.shift(1) == g.shift(2) + pd.offsets.MonthBegin(1))
good = base[base["ok"]]
grid = pd.MultiIndex.from_product([sorted(df["Month"].unique()), df["Category"].unique()], names=["Month","Category"]).to_frame(index=False)
result = grid.merge(good, on=["Month","Category"], how="left") \
    .groupby(["Month","Category"], as_index=False) \
    .agg(Count=("Cust_ID","nunique"), Customers=("Cust_ID", lambda x: np.nan if x.isna().all() else ", ".join(sorted(x.dropna().unique()))))
result["Month"] = result["Month"].dt.strftime("%Y-%m")


print(result.equals(test))
# True