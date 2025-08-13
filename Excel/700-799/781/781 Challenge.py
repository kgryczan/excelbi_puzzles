import pandas as pd
from itertools import combinations

path = "700-799/781/781 Common Between 2 Columns.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=12)
test = pd.read_excel(path, usecols="D", nrows=6).sort_values("Answer Expected").reset_index(drop=True)

cols  = [c for c in input.columns if c.startswith("Animals")]
sets  = {c: set(input[c].dropna().unique()) for c in cols}
pairs = {f"{a} & {b}": sorted(sets[a] & sets[b]) for a, b in combinations(cols, 2)}

k = 2
common_k = (
    input[cols].melt(var_name="col", value_name="a")
      .dropna().drop_duplicates(["col","a"])
      .value_counts("a")
      .loc[lambda s: s >= k].index.tolist()
)
common_k.sort()

print(common_k == test["Answer Expected"].to_list()) # True