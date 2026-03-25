import numpy as np
import pandas as pd

input_data = pd.read_excel("PQ_Challenge_160.xlsx", usecols="A:C", nrows=8)
test = pd.read_excel("PQ_Challenge_160.xlsx", usecols="F:M", nrows=8)

rows = []
for _, r1 in input_data.iterrows():
    row = {"Cities": r1["Cities"]}
    for _, r2 in input_data.iterrows():
        dist = round(np.sqrt((r2["x"] - r1["x"]) ** 2 + (r2["y"] - r1["y"]) ** 2), 2)
        row[r2["Cities"]] = dist
    rows.append(row)
result = pd.DataFrame(rows)

print(result.equals(test))
