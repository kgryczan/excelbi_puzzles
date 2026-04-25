import pandas as pd
import numpy as np
from functools import reduce

path = "300-399/385/PQ_Challenge_385.xlsx"
input = pd.read_excel(path, usecols="A", nrows=25, skiprows=0)
test = pd.read_excel(path, usecols="D:F", nrows=4, skiprows=0)

def parse_price(x):
    x = x.strip()
    if "%" in x:
        return float(x.replace("%","").replace("+","")) / 100
    return float(x)

def step(arr):
    def f(acc, v):
        if pd.isna(v):
            return acc
        if np.isclose(v, round(v)):
            return acc + v
        return acc + acc * v
    return reduce(f, arr, 0)

df = (
    input.iloc[:,0]
    .str.split(",", expand=True)
    .set_axis(["Product","Date","Type","Price"], axis=1)
)
df = df.iloc[1:]  # row_to_names equivalent
df["Date"] = pd.to_datetime(df["Date"])
df["Price"] = df["Price"].map(parse_price)
def calc(g):
    pos = g["Type"].map({"Base":1,"Override":2}).ffill()
    if pos.isna().all():
        return pd.Series({"Date": g["Date"].iloc[-1], "Price": np.nan})    
    last = pos.max()
    vals = g.loc[pos == last, "Price"]
    return pd.Series({
        "Date": g["Date"].iloc[-1],
        "Price": step(vals)
    })
result = (
    df.groupby("Product", group_keys=False)
      .apply(calc)
      .reset_index()
)
print(result.equals(test))
# True