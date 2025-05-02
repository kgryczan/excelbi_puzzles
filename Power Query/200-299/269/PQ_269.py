import pandas as pd
import networkx as nx

path = "PQ_Challenge_269.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=15)
test = pd.read_excel(path, usecols="D", nrows=12).sort_values(by="Result").reset_index(drop=True)

G = nx.from_pandas_edgelist(input, source='From City', target='To City', create_using=nx.DiGraph())
all_paths = ['-'.join(path) for target in G.nodes if target != 'City1' for path in nx.all_simple_paths(G, source='City1', target=target)]

df_paths = pd.DataFrame(all_paths, columns=['Path']).sort_values(by='Path').reset_index(drop=True)
print(df_paths['Path'].equals(test['Result'])) # True