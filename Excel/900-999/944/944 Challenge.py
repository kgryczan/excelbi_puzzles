import pandas as pd
import networkx as nx

path = "900-999/944/944 ES EF Calculation.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=21, skiprows=1)
test = pd.read_excel(path, usecols="E:G", nrows=21, skiprows=1).rename(columns=lambda c: c.rstrip(".1"))

df = input.copy()
edges = []
for t, deps in zip(df.Task, df.Dependencies):
    if pd.isna(deps):
        continue
    for d in str(deps).split(","):
        d = d.strip()
        if d:
            edges.append((d, t))

G = nx.DiGraph(edges)
G.add_nodes_from(df.Task)

dur = dict(zip(df.Task, df.Duration))
ES, EF = {}, {}

for t in nx.topological_sort(G):
    ES[t] = max((EF[p] for p in G.predecessors(t)), default=0)
    EF[t] = ES[t] + dur[t]

result = pd.DataFrame({"Task": list(ES), "ES": ES.values(), "EF": EF.values()}).sort_values("Task").reset_index(drop=True)

print(result.equals(test))
# True