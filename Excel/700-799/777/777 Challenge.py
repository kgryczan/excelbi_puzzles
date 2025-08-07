import pandas as pd
import numpy as np

path = "700-799/777/777 Reverse Flyod Triangle.xlsx"

input1 = pd.read_excel(path, usecols="A", skiprows=1, nrows=1, header=None).iloc[0, 0]
input2 = pd.read_excel(path, usecols="A", skiprows=4, nrows=1, header=None).iloc[0, 0]
input3 = pd.read_excel(path, usecols="A", skiprows=8, nrows=1, header=None).iloc[0, 0]

test1 = pd.read_excel(path, usecols="C:D", skiprows=1, nrows=2, header=None).values
test2 = pd.read_excel(path, usecols="C:E", skiprows=4, nrows=3, header=None).values
test3 = pd.read_excel(path, usecols="C:L", skiprows=8, nrows=10, header=None).values

def tri_matrix(n):
    mat = np.full((n, n), np.nan)
    for i in range(n):
        start = (i + 1) * (i + 2) // 2
        mat[i, :i+1] = np.arange(start, start - i - 1, -1)
    return mat

print(np.array_equal(tri_matrix(input1), test1, equal_nan=True)) # True
print(np.array_equal(tri_matrix(input2), test2, equal_nan=True)) # True
print(np.array_equal(tri_matrix(input3), test3, equal_nan=True)) # True