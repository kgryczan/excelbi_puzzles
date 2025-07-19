import numpy as np
import pandas as pd
import string

path = "700-799/763/763 Alphabets Staircase3.xlsx"
test = pd.read_excel(path, sheet_name=0, usecols="A:AA", skiprows=1, nrows=26, header=None).to_numpy()
input_matrix = np.full((26, 27), np.nan, dtype=object)

letters = list(string.ascii_uppercase)

for i in range(1, 27):
    idx = i - 1
    input_matrix[idx, idx] = letters[idx]
    input_matrix[idx, idx + 1] = letters[idx]
    if i % 2 == 0:
        input_matrix[idx - 1, idx + 1] = letters[idx]
        input_matrix[idx, idx] = np.nan

print(pd.DataFrame(input_matrix).equals(pd.DataFrame(test)))
