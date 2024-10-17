import pandas as pd
import numpy as np

path = "567  ASCII House.xlsx"
test = pd.read_excel(path, usecols="C:Q", skiprows=1, nrows=17, header=None).fillna("").values

M = np.full((17, 15), "", dtype=str)

for i in range(7):
    M[i, (7 - i):(7 + i + 1)] = "#"
M[16, :] = "#"
for i in range(7, 16):
    M[i, [1, 13]] = "#"
M[15, 1:14] = "#"
M[8:11, [3, 5]] = "#"
M[[8, 10], 4] = "#"
M[8:16, 8] = "#"
M[8, 9:11] = "#"
M[8:16, 11] = "#"

print(pd.DataFrame(M))

print((M == test).all()) # True