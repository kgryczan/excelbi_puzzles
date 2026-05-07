import pandas as pd

path = "900-999/972/Excel_Challenge_972 - Merging.xlsx"
inp = pd.read_excel(path, usecols="A", nrows=20)
exp = pd.read_excel(path, usecols="B", nrows=20).iloc[:, 0]

long = (
    inp.iloc[:, 0]
    .astype(str)
    .str.split(",")
    .explode()
    .str.strip()
    .rename("Data")
    .reset_index()
    .assign(rn=lambda d: d["index"] + 1)
)

parts = long["Data"].str.split("-", n=1, expand=True)
long = (
    long.assign(
        min=pd.to_numeric(parts[0], errors="coerce"),
        max=pd.to_numeric(parts[1], errors="coerce"),
    )
    .dropna(subset=["min", "max"])
    .sort_values(["rn", "min"], kind="mergesort")
)
long["group"] = (
    (long["min"] > long.groupby("rn")["max"].cummax().groupby(long["rn"]).shift())
    .fillna(False)
    .groupby(long["rn"])
    .cumsum()
)
result = (
    long.groupby(["rn", "group"])
    .agg(min=("min", "min"), max=("max", "max"))
    .assign(range=lambda d: d["min"].map("{:g}".format) + "-" + d["max"].map("{:g}".format))
    .groupby(level=0)["range"]
    .agg(", ".join)
    .reset_index(drop=True)
)

print(result.equals(exp))
# Output: True