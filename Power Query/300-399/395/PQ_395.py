import pandas as pd
import networkx as nx

path = "300-399/395/PQ_Challenge_395.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=21, skiprows=0)
test = pd.read_excel(path, usecols="D:E", nrows=21).rename(columns=lambda c: c.replace('.1', ''))

G = nx.Graph()
for index, row in input.iterrows():
    G.add_edge(row['Employee'], row['ReportsTo'])
report_counts = {}
for employee in G.nodes():
    if employee != 'CEO':
        report_counts[employee] = nx.shortest_path_length(G, source='CEO', target=employee)
report_counts_df = pd.DataFrame(list(report_counts.items()), columns=['Employee', 'Level'])

print(report_counts_df.equals(test))
# True