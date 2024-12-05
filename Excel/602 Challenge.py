import pandas as pd
import numpy as np

path = "602 Clarks Triangle.xlsx"
test = pd.read_excel(path,header=None, usecols="A:U", skiprows=1, nrows=11).fillna(0).to_numpy()

def create_clarks_matrix(n):
    mat = np.zeros((n, n * 2 - 1), dtype=int)
    mid = n - 1
    for i in range(n):
        for j in range(n * 2 - 1):
            if j == mid - i:
                mat[i, j] = 0 if i == 0 else 1
            elif j == mid + i:
                mat[i, j] = 6 * i
            elif i > 0 and j > 0 and j < n * 2 - 2 and mat[i - 1, j - 1] != 0 and mat[i - 1, j + 1] != 0:
                mat[i, j] = mat[i - 1, j - 1] + mat[i - 1, j + 1]
    return mat

n = 11
clark = create_clarks_matrix(n)

print(np.array_equal(clark, test))
# True