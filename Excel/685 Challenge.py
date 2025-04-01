import pandas as pd
import networkx as nx

def intervals_overlap(start1, end1, start2, end2):
    return max(start1, start2) <= min(end1, end2)

path = "685 Overlapping Tasks.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=8)
test = pd.read_excel(path, usecols="E", nrows=3)

input['interval_start'] = pd.to_datetime(input['Planned Start Date'])
input['interval_end'] = pd.to_datetime(input['Planned End Date'])

tasks = pd.merge(input, input, how='cross')
tasks = tasks[tasks['Task_x'] < tasks['Task_y']]
tasks['overlap'] = tasks.apply(
    lambda row: intervals_overlap(
        row['interval_start_x'], row['interval_end_x'],
        row['interval_start_y'], row['interval_end_y']
    ),
    axis=1
)
tasks = tasks[tasks['overlap']][['Task_x', 'Task_y']]

g = nx.Graph()
g.add_edges_from(tasks.values)
subgraphs = [", ".join(sorted(component)) for component in nx.connected_components(g)]
subgraphs_df = pd.DataFrame({'ans': sorted(subgraphs)})

print(subgraphs_df['ans'].equals(test['Anwer Expected']))  # True
