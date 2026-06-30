import pandas as pd
import numpy as np

path = "1000-1099/1010/1010 Record Alignment.xlsx"
input = pd.read_excel(path, usecols="A", nrows=23, skiprows=1)
test = pd.read_excel(path, usecols="C:E", nrows=5, skiprows=1)

df = input.copy()
first_col = df.columns[0]
if first_col != "Data":
    df = df.rename(columns={first_col: "Data"})
df["count"] = df["Data"].isna().cumsum() + 1
df = df.dropna(subset=["Data"]).copy()
df["nr"] = df.groupby("count").cumcount() + 1
df["adj_nr"] = np.where(
    (df["nr"] == 3) & (~df["Data"].astype(str).str.contains(r"\d", na=False)),
    4,
    df["nr"],
)
wide = df.pivot(index="count", columns="adj_nr", values="Data").reset_index(drop=True)
wide["Full Name"] = (
    wide.reindex(columns=[1, 2])
    .fillna("")
    .agg(" ".join, axis=1)
    .str.replace(r"\s+", " ", regex=True)
    .str.strip()
)
wide["Age"] = pd.to_numeric(wide.get(3), errors="coerce")
wide["City"] = wide.get(4)
result = wide[["Full Name", "Age", "City"]]

print(result.equals(test))
# True
