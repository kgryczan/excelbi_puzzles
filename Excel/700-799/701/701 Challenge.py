import pandas as pd
import numpy as np

path = "701 Swap Diagonals.xlsx"
input_matrix = pd.read_excel(path, sheet_name=0, usecols="A:J", skiprows=1, nrows=10, header=None).to_numpy()
test_matrix = pd.read_excel(path, sheet_name=0, usecols="L:U", skiprows=1, nrows=10, header=None).to_numpy()

def swap_diagonals(matrix):
    for i in range(len(matrix)):
        matrix[i][i], matrix[i][~i] = matrix[i][~i], matrix[i][i]
    return matrix

res_matrix = swap_diagonals(input_matrix.copy())

print(np.array_equal(res_matrix, test_matrix)) # True