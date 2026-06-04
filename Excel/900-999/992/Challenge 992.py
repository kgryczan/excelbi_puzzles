import pandas as pd
from itertools import combinations

path = "900-999/992/992 Maximal Combinations.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=28, skiprows=1)
test = pd.read_excel(path, usecols="D:E", nrows=10, skiprows=1)

items_by_order = input.groupby("OrderID", sort=False)["Item"].apply(list)

result = (
	pd.DataFrame(
		(
			(",".join(sorted(map(str, c))), len(c))
			for items in items_by_order
			for k in range(2, min(4, len(items)) + 1)
			for c in combinations(items, k)
		),
		columns=["Combination", "length"],
	)
	.groupby(["Combination", "length"], as_index=False)
	.size()
	.rename(columns={"size": "Support"})
	.loc[lambda d: d["Support"] >= 2]
	.sort_values(["length", "Support", "Combination"], ascending=[False, False, True])
	.drop(columns="length")
	.reset_index(drop=True)
)

# Support identical, order of combination in test is inconsistent.