import pandas as pd
import numpy as np

path = "501 Find Consecutives in Grid.xlsx"
input = pd.read_excel(path, header=None, skiprows=1, usecols="B:M")
test = pd.read_excel(path, usecols="O:O", nrows = 5)

matrix = input.to_numpy()
tmatrix = matrix.T
in_cols = np.unique(matrix[:, :-1][matrix[:, :-1] == matrix[:, 1:]])
in_rows = np.unique(tmatrix[:, :-1][tmatrix[:, :-1] == tmatrix[:, 1:]])
result = pd.DataFrame(np.sort(np.unique(np.concatenate((in_rows, in_cols))))).\
    rename(columns={0: "Answer Expected"}).astype("int64")

print(result.equals(test))  # True