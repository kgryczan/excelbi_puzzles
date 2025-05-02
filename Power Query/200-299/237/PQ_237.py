import pandas as pd
import numpy as np
path = "PQ_Challenge_237.xlsx"

input = pd.read_excel(path, usecols="A:E", nrows=11)
test = pd.read_excel(path, usecols="G:K", nrows=11).rename(columns=lambda x: x.split('.')[0])

result = input.apply(lambda col: col.where(
col.notna(), 
[f"{col.name}_{sum(pd.isna(col[:i]))+1}" if pd.isna(val) else val for i, val in enumerate(col)]
))

result = result.map(lambda x: np.int64(x) if isinstance(x, (int, float)) and not np.isnan(x) else x)
test = test.map(lambda x: np.int64(x) if isinstance(x, (int, float)) and not np.isnan(x) else x)

print(result.equals(test)) # True