import numpy as np
import pandas as pd

path = "700-799/715/715 - Alphabetic Triangle.xlsx"
input_n = 15
test = pd.read_excel(path, header=None, skiprows=1, nrows=15, usecols="B:P").values

def make_letter_triangle_matrix(n):
    seq = [chr(ord('A') + i % 26) for i in range(n * (n + 1) // 2)]
    mat = np.full((n, n), np.nan, dtype=object)
    idx = 0
    for i in range(n):
        mat[i, :i+1] = seq[idx:idx+i+1]
        idx += i + 1
    return mat

result = make_letter_triangle_matrix(input_n)
print(result.all() == test.all()) # True