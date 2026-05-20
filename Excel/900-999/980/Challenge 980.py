import pandas as pd
from itertools import permutations

path = "900-999/980/980 Max and Min Numbers.xlsx"
input = pd.read_excel(path, usecols="A:E", nrows=11, skiprows=1, dtype=str)
test = pd.read_excel(path, usecols="F:G", nrows=11, skiprows=1, dtype=str)

long_df = (
	input.assign(rn=range(1, len(input) + 1))
	.melt(id_vars="rn", value_name="value")
	.dropna(subset=["value"])
)
long_df["value"] = long_df["value"].astype(str).str.replace(r"0\.", ".", regex=True)
rows = []
for rn, grp in long_df.groupby("rn", sort=False):
	values = grp["value"].tolist()
	combinations = {"".join(p) for p in permutations(values, len(values))}
	comb_df = pd.DataFrame({"rn": rn, "combination": list(combinations)})
	comb_df["num_combination"] = pd.to_numeric(comb_df["combination"], errors="coerce")
	comb_df = comb_df.dropna(subset=["num_combination"])
	if comb_df.empty:
		continue
	min_val, max_val = comb_df["num_combination"].agg(["min", "max"])
	mm = comb_df[comb_df["num_combination"].isin([min_val, max_val])].copy()
	mm["minmax"] = mm["num_combination"].map(
		lambda x: "MIN" if x == min_val else "MAX"
	)
	rows.append(mm[["rn", "combination", "minmax"]])
if rows:
	result = (
		pd.concat(rows, ignore_index=True)
		.drop_duplicates()
		.pivot_table(index="rn", columns="minmax", values="combination", aggfunc="first")
		.reset_index(drop=True)
		.reindex(columns=["MIN", "MAX"])
	)
	result.columns.name = None
else:
	result = pd.DataFrame(columns=["MIN", "MAX"])

# Some discrepancies.