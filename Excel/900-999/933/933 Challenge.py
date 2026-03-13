import numpy as np
import pandas as pd

path = "900-999/933/933 Number Pattern.xlsx"

input1 = pd.read_excel(path, sheet_name="Sheet1 (2)", usecols="A", skiprows=1, nrows=1, header=None).iloc[0, 0]
test1 = pd.read_excel(path, sheet_name="Sheet1 (2)", usecols="C:G", skiprows=1, nrows=3, header=None).fillna(0).astype(int).to_numpy()
input2 = pd.read_excel(path, sheet_name="Sheet1 (2)", usecols="A", skiprows=5, nrows=1, header=None).iloc[0, 0]
test2 = pd.read_excel(path, sheet_name="Sheet1 (2)", usecols="C:I", skiprows=5, nrows=4, header=None).fillna(0).astype(int).to_numpy()
input3 = pd.read_excel(path, sheet_name="Sheet1 (2)", usecols="A", skiprows=10, nrows=1, header=None).iloc[0, 0]
test3 = pd.read_excel(path, sheet_name="Sheet1 (2)", usecols="C:Q", skiprows=10, nrows=8, header=None).fillna(0).astype(int).to_numpy()

def fill_matrix(n):
    mat = np.zeros((n, 2*n-1), dtype=int)
    for r in range(1, n+1):
        v = np.arange(r*(r-1)//2 + 1, r*(r+1)//2 + 1)
        mat[r-1, :r] = v
        mat[r-1, 2*n-r-1:] = v[::-1]
    return mat

print(np.array_equal(test1, fill_matrix(input1))) # True
print(np.array_equal(test2, fill_matrix(input2))) # True
print(np.array_equal(test3, fill_matrix(input3))) # True