import pandas as pd
import numpy as np

path = "673 Star Pattern.xlsx"

test3 = pd.read_excel(path, usecols="C:E", skiprows=2, nrows=3, header=None).fillna('').values
test4 = pd.read_excel(path, usecols="C:F", skiprows=6, nrows=4, header=None).fillna('').values
test7 = pd.read_excel(path, usecols="C:I", skiprows=11, nrows=7, header=None).fillna('').values

def make_star(side):
    M = np.full((side, side), '', dtype=str)
    M = np.array([[chr(65 + i) if j == i or j == side - 1 - i else '' for j in range(side)] for i in range(side)])
    return M

print(np.array_equal(make_star(3), test3))  # True
print(np.array_equal(make_star(4), test4))  # True
print(np.array_equal(make_star(7), test7))  # True
