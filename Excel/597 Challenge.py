import pandas as pd
import numpy as np
from pprint import pprint

path = "597 Pentagram.xlsx"
test = pd.read_excel(path, header=None, usecols="C:U", skiprows=2, nrows=13).values
test = np.where(pd.isna(test), "", test)

M = [["" for _ in range(19)] for _ in range(13)]
middle_col_index = len(M[0]) // 2

def draw_x_pattern(matrix, middle_index):
    for i in range(0, len(matrix)):
        if middle_index - i >= 0:
            matrix[i][middle_index + i] = "x"
            matrix[i][middle_index - i] = "x"

draw_x_pattern(M, middle_col_index)
M = M[::-1]
draw_x_pattern(M, middle_col_index)

row_indexes_with_x = [index for index, row in enumerate(M) if row[0] == "x"]

for index in row_indexes_with_x:
    M[index] = ["x" for _ in range(len(M[index]))]

df = pd.DataFrame(M)
test = pd.DataFrame(test)

print(df.equals(test))
