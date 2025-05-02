import pandas as pd
import numpy as np

path = "592 Bell Triangle.xlsx"
input_value = pd.read_excel(path, usecols="B", nrows=1, skiprows=1, header=None).iloc[0, 0]
test_10 = pd.read_excel(path, usecols="A:J", skiprows=3, nrows=10, header=None).fillna(0).values.astype(int)

M = np.full((input_value, input_value), -1, dtype=int)
M[0, 0] = 1
for i in range(1, input_value):
    M[i, 0] = M[i - 1, i - 1]
    for j in range(1, i + 1):
        M[i, j] = M[i, j - 1] + M[i - 1, j - 1]
M[M == -1] = 0

print(np.array_equal(M, test_10))   # True
 