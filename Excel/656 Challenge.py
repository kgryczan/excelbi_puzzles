import pandas as pd
import networkx as nx

input = pd.read_excel("656 Critical Path.xlsx", usecols="A:C", skiprows=1, nrows=10).dropna(subset=['Predecessor '])
input = input.assign(Predecessor=input['Predecessor '].str.split(',')).explode('Predecessor')[['Task', 'Duration', 'Predecessor']]

G = nx.from_pandas_edgelist(input, 'Predecessor', 'Task', ['Duration'], create_using=nx.DiGraph())
longest_path = nx.dag_longest_path(G, weight='Duration')

lp = pd.DataFrame(longest_path, columns=['path']).merge(input, left_on='path', right_on='Task', how='left')[['Task', 'Duration']].dropna()
summary = pd.DataFrame({'Task': ['Start-' + '-'.join(lp['Task']) + '-End'], 'Duration': [lp['Duration'].sum().astype("int64")]})

test = pd.read_excel("656 Critical Path.xlsx", usecols="D:E", skiprows=1, nrows=1)
test.columns = summary.columns
print(summary.equals(test))  # True
