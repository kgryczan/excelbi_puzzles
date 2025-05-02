import pandas as pd
import numpy as np

path = "PQ_Challenge_268.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=15)
test = pd.read_excel(path, usecols="E:J", nrows=6).fillna("").rename(columns=lambda col: col.split('.')[0])

input['row'] = np.arange(len(input))
melted = input.melt(id_vars="row", value_name="value").dropna(subset=["value"])
melted["value1"] = melted["value"]
splits = melted["value"].str.extract(r"^([^\d]+)(.*)$")
melted["name"] = splits[0]
melted["value"] = splits[1]
result = melted.pivot_table(index="value", columns="name", values="value1", aggfunc="first")
result = result.reindex(sorted(result.columns), axis=1)
result = result.fillna("").reset_index(drop=True)

result.columns = test.columns

print(result.equals(test)) # True