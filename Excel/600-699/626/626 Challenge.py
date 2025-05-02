import pandas as pd
import numpy as np

path = "626 List Unique Across Columns.xlsx"
input = pd.read_excel(path, usecols="A:i", nrows=19)
test = pd.read_excel(path, usecols="k:s", nrows=19)

cols = [f"Col{i}" for i in range(1, 10)]
input.columns = test.columns = cols

input = pd.DataFrame({col: pd.Series(pd.unique(input[col][::-1])[::-1]).reindex(range(len(input)), fill_value=np.nan) for col in cols})

print(all(input == test)) # True