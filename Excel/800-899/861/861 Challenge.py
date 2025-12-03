import pandas as pd
import re
import numpy as np

path = "Excel/800-899/861/861 Transpose.xlsx"
input = pd.read_excel(path, sheet_name=1, usecols="A:B", skiprows=1, nrows=4)
test = pd.read_excel(path, sheet_name=1, usecols="D:G", skiprows=1, nrows=8).rename(columns=lambda c: c.replace('.1', ''))
df = input.map(lambda x: re.sub(r" ", "", x) if isinstance(x, str) else x)

df = (
    df.assign(
        Company=df["Company"].str.split(r"[;,]"),
        Revenue=df["Revenue"].apply(lambda x: x.split(",") if isinstance(x, str) and "," in x else [x])
    )
    .explode(["Company", "Revenue"])
)
regex = r"^([A-Za-z]+)-(\d+):\s*(.+)$"
df[["Code", "ID", "Company"]] = (
    df["Company"]
    .str.extract(regex)
)
result = (
    df.assign(
        Revenue=lambda d: pd.to_numeric(d["Revenue"]).astype(np.int64),
        ID=lambda d: pd.to_numeric(d["ID"]).astype(np.int64)
    )
    .sort_values(["Code", "Company"])
    .reset_index(drop=True)
    [["Code", "ID", "Company", "Revenue"]]
)

print(result.equals(test)) # True