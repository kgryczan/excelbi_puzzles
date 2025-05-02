import pandas as pd
import numpy as np
from itertools import product

path = "704 WhereMaxBlock.xlsx"
input_data = pd.read_excel(path, sheet_name=0, header=None, skiprows=2, usecols="A:J").to_numpy()
test = pd.read_excel(path, sheet_name=0, usecols="L", nrows=2).squeeze().to_list()

nr, nc = input_data.shape
submatrices = []
for i, j, k, l in product(range(nr), range(nc), range(1, nr + 1), range(1, nc + 1)):
    if k > i and l > j:
        submatrices.append(input_data[i:k, j:l])
submatrices_df = pd.DataFrame({
    "sum": [np.nansum(submatrix) for submatrix in submatrices],
    "dims": [f"{submatrix.shape[0]} x {submatrix.shape[1]}" for submatrix in submatrices],
    "start_cell": [
        f"{np.where(input_data == submatrix[0, 0])[0][0] + 1} x {np.where(input_data == submatrix[0, 0])[1][0] + 1}"
        for submatrix in submatrices
    ]
})

max_submatrix = submatrices_df.loc[submatrices_df["sum"].idxmax()]
result = f"({max_submatrix['dims']}), {max_submatrix['sum']}, [{max_submatrix['start_cell']}]"
print(result)
