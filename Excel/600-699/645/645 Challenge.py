import pandas as pd
import numpy as np

path = "645 Align WBS Data.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=30)
test = pd.read_excel(path, usecols="E:J", nrows=30)

def process_data(input):
    for i in range(6):
        col = str(i)
        input[col] = np.where(input['WBS'].str.contains(f'WBS_{col}'), input['WBS'], np.nan)
        input[col] = input[col].ffill() if i == 0 else input.groupby(str(i - 1))[col].ffill()
    return input.fillna("XXX").drop(columns=['WBS', 'ID'])

result = process_data(input)
result.columns = test.columns

print(result.equals(test)) # True