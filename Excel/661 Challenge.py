import pandas as pd
import numpy as np

path = "661 Matrix Transformation.xlsx"
M1 = pd.read_excel(path, usecols="B:F", skiprows=1, nrows=5, header=None).values
M2 = pd.read_excel(path, usecols="I:M", skiprows=1, nrows=5, header=None).values
M3 = pd.read_excel(path, usecols="P:T", skiprows=1, nrows=5, header=None).values

M1_values = M1.flatten()

MT = np.full(M1.shape, np.nan)

def fill_mrow(MT, M1_values, row_index):
    empty_cells = np.where(np.isnan(MT[row_index,]))[0]
    max_value = np.nanmax(MT)
    values_to_fill = M1_values[M1_values > max_value][:len(empty_cells)]
    MT[row_index, empty_cells] = values_to_fill
    return MT

def fill_mcol(MT, M1_values, col_index):
    empty_cells = np.where(np.isnan(MT[:, col_index]))[0]
    max_value = np.nanmax(MT)
    values_to_fill = M1_values[M1_values > max_value][:len(empty_cells)]
    MT[empty_cells, col_index] = values_to_fill
    return MT

for i in range(5):
    MT = fill_mrow(MT, M1_values, i)
    MT = fill_mcol(MT, M1_values, i)

print(np.array_equal(MT, M2))

# ---- reverse transformation ----

# def extract_alternating(M):
#     result = []
#     while M.shape[0] > 0 and M.shape[1] > 0:
#         result.append(M[0, :])
#         M = M[1:, :]
#         if M.shape[0] > 0:
#             result.append(M[:, 0])
#             M = M[:, 1:]
#     return result

# M2T = extract_alternating(M2)
# M2T = np.concatenate(M2T).reshape(5, 5)
# print(np.array_equal(M2T, M3))