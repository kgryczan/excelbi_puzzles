import pandas as pd
import numpy as np

path = "700-799/796/796 Pattern Drawing.xlsx"
test = pd.read_excel(path, header=None, usecols="B:R", skiprows=1, nrows=17).values

def bowtie_matrix(n):
    size = 2 * n - 1
    mat = np.full((size, size), np.nan) 
    for r in range(size):
        k = r + 1 if r < n else size - r  
        mat[r, :k] = np.arange(k, 0, -1)
        mat[r, size - k:] = np.arange(1, k + 1)
    return mat

result = bowtie_matrix(9)
print(np.array_equal(test, result, equal_nan=True)) # True
