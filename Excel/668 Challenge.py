import pandas as pd
import numpy as np

path = "668 Alphabetic Z.xlsx"

test3 = pd.read_excel(path, usecols="B:D", skiprows=1, nrows=3, header=None).fillna("").to_numpy()
test4 = pd.read_excel(path, usecols="B:E", skiprows=5, nrows=4, header=None).fillna("").to_numpy()
test6 = pd.read_excel(path, usecols="B:G", skiprows=10, nrows=6, header=None).fillna("").to_numpy()
test9 = pd.read_excel(path, usecols="B:J", skiprows=17, nrows=9, header=None).fillna("").to_numpy()
test12 = pd.read_excel(path, usecols="B:M", skiprows=27, nrows=13, header=None).fillna("").to_numpy()

def draw_z(side):
    L2 = list("ABCDEFGHIJKLMNOPQRSTUVWXYZ") * 2
    M = np.full((side, side), "", dtype=object)
    M[0, :] = L2[:side]
    for i in range(side):
        M[i, side - i - 1] = L2[side + i - 1]
    M[side-1, :] = L2[(2 * side - 2):(3 * side - 2)]
    return M

print(np.array_equal(draw_z(3), test3)) # True
print(np.array_equal(draw_z(4), test4)) # True
print(np.array_equal(draw_z(6), test6)) # True
print(np.array_equal(draw_z(9), test9)) # True
print(np.array_equal(draw_z(12), test12))  # Different structure of Z
