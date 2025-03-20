import numpy as np
import pandas as pd

path = "677 Generate the Pattern.xlsx"
test = pd.read_excel(path, sheet_name=0, usecols="B:R", skiprows=1, nrows=9, header=None).fillna("").to_numpy()

M = np.full((9, 17), "", dtype=object)
def generate_sequence(X):
    return [x for x in range(X, 0, -1)] + [x for x in range(2, X + 1)]
M = np.array([generate_sequence(i) + [""] * (17 - len(generate_sequence(i))) for i in range(1, 10)], dtype=object)

print(np.array_equal(M, test))
