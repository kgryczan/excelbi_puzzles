import pandas as pd
import numpy as np

path = "641 Wrap the Row.xlsx"
input = pd.read_excel(path, usecols="A", nrows=12)
test = pd.read_excel(path, usecols="B:E", nrows=5, names=["N1", "N2", "N3", "N4"])
test = test.astype('float64')

input['row'] = (input['Numbers'].diff().abs().gt(2) | input['Numbers'].shift().isna()).cumsum()
input['num'] = 'N' + (input.groupby('row').cumcount() + 1).astype(str)

result = input.pivot(index='row', columns='num', values='Numbers').reset_index(drop=True).rename_axis(None, axis=1).astype('float64')

print(result.equals(test)) # True