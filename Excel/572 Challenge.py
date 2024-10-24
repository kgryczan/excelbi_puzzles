import pandas as pd
import numpy as np

path = "572 Pivot Problem.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=14)
test = pd.read_excel(path, usecols="D:I", nrows=5, skiprows=1)

input['Week'] = np.ceil((pd.to_datetime(input['Date']).dt.day - 1) // 7 + 1).astype("int64")
result = input.pivot_table(index='Week', columns='Value', values='Date', aggfunc='size', fill_value=0).reset_index().rename_axis(None, axis=1)
result = result[['Week', 1, 2, 3, 4, 5]]

test.columns = result.columns

print(result.equals(test)) # True   
