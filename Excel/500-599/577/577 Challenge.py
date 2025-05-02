import pandas as pd
import numpy as np

path = "577 Make ASCII Lamp.xlsx"
test = pd.read_excel(path, header=None, usecols="C:W", skiprows=1, nrows=10)
test = test.fillna("")
test = test.to_numpy()

def centered(matrix, row, how_many):
    pad = (matrix.shape[1] - how_many) // 2
    matrix[row, pad:pad + how_many] = "x"
    return matrix

M = np.full((10, 21), "", dtype=object)

for i in range(1, 10):
    how_many = 1 if i < 3 else 3 if i < 6 else 21 - (i - 6) * 2
    M = centered(M, i, how_many)

print(np.array_equal(M, test)) # True
