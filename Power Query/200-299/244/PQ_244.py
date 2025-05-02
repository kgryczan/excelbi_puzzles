import pandas as pd

path = "PQ_Challenge_244.xlsx"
input1 = pd.read_excel(path, usecols="A:F", nrows=6)
input2 = pd.read_excel(path, usecols="A:F", skiprows=8, nrows=4)
test = pd.read_excel(path, usecols="I:O", nrows=7).rename(columns=lambda x: x.split('.')[0])

melted = pd.concat([input1, input2]).melt(id_vars='Student', var_name="Subject", value_name="Score").dropna(subset=['Score'])
pivoted = melted.pivot_table(index='Student', columns='Subject', values='Score', aggfunc='sum').reset_index()
pivoted.columns.name = None

print(all(pivoted == test)) # True
