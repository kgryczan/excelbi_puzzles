import pandas as pd
import networkx as nx

path = "900-999/983/983 Connected Nodes Networks.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=21, skiprows=0)
test = pd.read_excel(path, usecols="C", nrows=6, skiprows=0)

G = nx.from_pandas_edgelist(input, source='Node_1', target='Node_2')
connected_components = list(nx.connected_components(G))
connected_components = [sorted(list(component)) for component in connected_components]
result = pd.DataFrame({'Answer Expected': [', '.join(component) for component in connected_components]})
result['Num_Nodes'] = result['Answer Expected'].apply(lambda x: len(x.split(', ')))
result = result.sort_values(by=['Num_Nodes', 'Answer Expected'], ascending=[False, True]).reset_index(drop=True)
result = result.drop(columns=['Num_Nodes'])
print(result.equals(test))
# True