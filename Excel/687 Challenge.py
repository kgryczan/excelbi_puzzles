import pandas as pd
import numpy as np

path = "687 Fill Grid with Max Right and Down.xlsx"

input_matrix = pd.read_excel(path, usecols="A:J", skiprows=1, nrows=10, header=None).to_numpy()
test_matrix = pd.read_excel(path, usecols="A:J", skiprows=13, nrows=10, header=None).to_numpy()

def fill_empty(matrix, row, col):
    return np.nanmax(np.r_[matrix[row, col:], matrix[row:, col]])

empty_cells = np.argwhere(np.isnan(input_matrix))
filled_values = [fill_empty(input_matrix, row, col) for row, col in empty_cells]
result = np.allclose(filled_values, test_matrix[tuple(empty_cells.T)], equal_nan=True)

print(result)
