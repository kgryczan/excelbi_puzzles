import pandas as pd
import numpy as np

path = "553 ASCII Abacus.xlsx"
test = pd.read_excel(path, header=None, usecols="B:T", nrows=12, skiprows=1).values

M = np.full((12, 19), np.nan, dtype=object)

for i in range(12):
    for j in range(19):
        if i in [0, 4, 11]:
            M[i, j] = "---"
        elif i in [1, 5]:
            M[i, j] = "|"
        else:
            M[i, j] = "O"

for i in range(1, 11):
    M[i, 0] = "|"
    M[i, 18] = "|"

print(np.all(M == test)) # True
