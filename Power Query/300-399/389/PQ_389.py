import pandas as pd
from collections import Counter

path = "300-399/389/PQ_Challenge_389.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=29)
test = pd.read_excel(path, usecols="E:H", nrows=24).rename(
	columns=lambda c: c.replace(".1", "") if isinstance(c, str) else c
)

for df in (input, test):
	n = df.select_dtypes(include="number").columns
	df[n] = df[n].astype(float)
result = input.copy()
windows = [slice(i - 2, i + 3) if 1 < i < len(result) - 2 else None for i in range(len(result))]
result["sum"] = [result["Value"].iloc[w].sum() if w else pd.NA for w in windows]
result["conc"] = ["".join(result["Code"].iloc[w].astype(str)) if w else pd.NA for w in windows]
result["most_common"] = [
	sorted(Counter(result["Code"].iloc[w]).items(), key=lambda x: (-x[1], str(x[0])))[0][0] if w else pd.NA
	for w in windows
]
result = result.dropna().loc[:, ["ID", "conc", "sum", "most_common"]].rename(
	columns={"conc": "Pattern", "sum": "WindowValueSum", "most_common": "DominantCode"}
).reset_index(drop=True)

print(all(result == test))
