import pandas as pd
import numpy as np

path = "523 Alphabets Staircase.xlsx"
given_number = pd.read_excel(path, usecols="B", header=None, skiprows=1, nrows=1).iloc[0, 0]
test = pd.read_excel(path, skiprows=3, header=None)

M = [[np.NaN for _ in range(given_number * 2 + 1)] for _ in range(given_number)]

for i in range(given_number):
    start_col = 2 * i
    M[i][start_col:start_col + 3] = [chr(ord('A') + i)] * 3

M = pd.DataFrame(M).dropna(axis=0, how='all').dropna(axis=1, how='all')
M.columns = test.columns

print(M.equals(test)) # True
