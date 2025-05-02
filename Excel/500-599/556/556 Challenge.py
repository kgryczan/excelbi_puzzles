import pandas as pd
import numpy as np

path = "556 Generate Triangle Cumsum.xlsx"
input_value = pd.read_excel(path, usecols="A", nrows=1, header=None).iloc[0, 0]
test = pd.read_excel(path, usecols="B:T", skiprows=1, nrows=10, header=None).values

M = np.full((input_value, 2 * input_value - 1), np.nan)
p = np.cumsum(np.arange(1, 11))

for i in range(10):
    M[i, (input_value - i - 1):(input_value + i)] = p[::-1][i]

print(np.allclose(M, test, equal_nan=True)) # True