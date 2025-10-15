import pandas as pd
import numpy as np

path = "800-899/826/826 Align Cities.xlsx"
input = pd.read_excel(path, usecols="A:E", nrows=19)
test = pd.read_excel(path, usecols="G:K", nrows=19).rename(columns=lambda c: c.replace('.1', ''))

inp_set = input.notna().sum().values
cities = sorted([c for c in pd.unique(input.values.ravel('K')) if pd.notna(c)])
starts = np.cumsum([0] + list(inp_set[:-1]))
cols = [
    list(cities[start:start + count]) + [np.nan] * (18 - count)
    for start, count in zip(starts, inp_set)
]
result = pd.DataFrame({col: vals for col, vals in zip(input.columns, cols)})

print(result.equals(test))  # Trues