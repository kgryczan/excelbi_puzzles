import numpy as np
import pandas as pd

path = "700-799/779/779 Linked_in_Block_Shift.xlsx"

input_mat = pd.read_excel(path, header=None, usecols="B:F", skiprows=1, nrows=3).to_numpy()
col_rot = pd.read_excel(path, header=None, usecols="B:F", nrows=1).to_numpy(dtype=int).flatten()
row_rot = pd.read_excel(path, header=None, usecols="A", skiprows=1, nrows=3).to_numpy(dtype=int).flatten()
test_mat = pd.read_excel(path, header=None, usecols="H:L", skiprows=1, nrows=3).to_numpy()

def apply_rotations(mat, row_rot, col_rot):
    mat = np.array([np.roll(row, shift) for row, shift in zip(mat, row_rot)])
    mat = np.array([np.roll(col, shift) for col, shift in zip(mat.T, col_rot)]).T
    return mat

def find_iteration(start, target, row_rot, col_rot, max_iter=1000):
    mat = start.copy()
    for i in range(1, max_iter + 1):
        mat = apply_rotations(mat, row_rot, col_rot)
        if np.array_equal(mat, target): return i
    return None

# Minimal iteratrions to reach the target matrix
print(find_iteration(input_mat, test_mat, row_rot, col_rot))
# 32

# Check if 50k iterations yield the same result
result_50000 = input_mat.copy()
for _ in range(50000):
    result_50000 = apply_rotations(result_50000, row_rot, col_rot)
print(np.array_equal(result_50000, test_mat))
# True