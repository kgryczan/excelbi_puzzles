import pandas as pd
import numpy as np
import string

path = "627 Alphabets Staircase_2.xlsx"
test = pd.read_excel(path, header=None, usecols="A:BA", nrows=52, skiprows=1)

al = list(string.ascii_uppercase)
M = np.full((52, 53), np.nan, dtype=object)

for i in range(1, 27):
    indices = [(2*i - 2, 2*i - 2), (2*i - 2, 2*i - 1), (2*i - 2, 2*i), (2*i - 1, 2*i)]
    for index in indices:
        M[index[0], index[1]] = al[i-1]

M = pd.DataFrame(M)
test.columns = M.columns

print(test.equals(M))
