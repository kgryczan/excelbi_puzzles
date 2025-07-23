import numpy as np
import pandas as pd

path = "700-799/766/766 Swap Diagonals.xlsx"
input = pd.read_excel(path, header=None, usecols="A:J", skiprows=1, nrows=10).values
test  = pd.read_excel(path, header=None, usecols="L:U", skiprows=1, nrows=10).values

def swap_diagonals(mat):
    mat = mat.copy()
    n = mat.shape[0]
    idx = np.arange(n)
    mat[idx, idx] = mat[idx, idx][::-1]
    mat[idx, n-1-idx] = mat[idx, n-1-idx][::-1]
    return mat

result = swap_diagonals(input)
print(np.allclose(result, test)) # True