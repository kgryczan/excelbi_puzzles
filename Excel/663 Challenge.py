import pandas as pd
import numpy as np

path = "663 Pivot for levels.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=10)
test = pd.read_excel(path, usecols="D:I", skiprows=1, nrows=3).astype(np.float64)

input[['Level', 'Sublevel']] = input['Level'].astype(str).str.split('.', expand=True).fillna('0').astype(float)
result = input.pivot(index='Level', columns='Sublevel', values='Value').reset_index()
result.columns.name = None
test.columns = result.columns

print(result.equals(test)) # True