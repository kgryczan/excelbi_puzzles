import pandas as pd
import numpy as np

path = "800-899/807/807 Fill in With Previous Odd Number.xlsx"

input_mat = pd.read_excel(path, sheet_name=1, usecols="A:F", skiprows=1, nrows=9, header=None).values
test_mat = pd.read_excel(path, sheet_name=1, usecols="H:M", skiprows=1, nrows=9, header=None).values

flat = input_mat.flatten()
v2 = np.where(flat % 2 == 1, flat, np.nan)
v2 = pd.Series(v2).ffill().values
v2 = np.where(~np.isnan(flat), flat, v2)
r1 = v2.reshape(input_mat.shape)

comparison = (r1 == test_mat)

print(comparison) # One field has empty value in input matrix
