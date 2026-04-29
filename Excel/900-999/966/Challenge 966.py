import pandas as pd
import networkx as nx

path = "900-999/966/966 Least Cost Path.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=16, skiprows=1)
test = pd.read_excel(path, usecols="E:F", nrows=1, skiprows=1)

edges = (
	input.assign(
		ValidDestinations=input["ValidDestinations"].str.split(",")
	)
	.explode("ValidDestinations")
	.assign(ValidDestinations=lambda d: d["ValidDestinations"].str.strip())
	.dropna(subset=["ValidDestinations"])
	.loc[lambda d: d["ValidDestinations"].ne(""), ["NodeID", "ValidDestinations"]]
	.rename(columns={"NodeID": "from", "ValidDestinations": "to"})
)
g = nx.from_pandas_edgelist(edges, source="from", target="to", create_using=nx.DiGraph())
cost_map = input.set_index("NodeID")["EntryCost"].to_dict()
starts = [n for n in g if str(n).startswith("A")]
ends = [n for n in g if str(n).startswith("E")]
rows = [
	{
		"Path": ",".join(p),
		"Total Cost": sum(cost_map.get(n, 0) for n in p),
	}
	for s in starts
	for t in ends
	if nx.has_path(g, s, t)
	for p in nx.all_simple_paths(g, source=s, target=t)
]
res = (
	pd.DataFrame(rows)
	.nsmallest(1, "Total Cost")
	.reset_index(drop=True)
	if rows
	else pd.DataFrame(columns=["Path", "Total Cost"])
)

print(res.equals(test))
# True