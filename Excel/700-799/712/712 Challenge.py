import pandas as pd
import numpy as np

path = "700-799/712/712 Rotate Quadrangle.xlsx"

input = pd.read_excel(path, sheet_name=0, usecols="A:I", skiprows=1, nrows=9, header=None).to_numpy()
test = pd.read_excel(path, sheet_name=0, usecols="L:T", skiprows=1, nrows=9, header=None).to_numpy()

coords = np.argwhere(~np.isnan(input))
values = input[~np.isnan(input)]

def shift(r, c, n_rows=9, n_cols=9):
    if 0 <= r <= 4 and 0 <= c <= 3:
        nr, nc = r - 1, c + 1
    elif 0 <= r <= 3 and 4 <= c <= n_cols - 1:
        nr, nc = r + 1, c + 1
    elif 4 <= r <= n_rows - 1 and 5 <= c <= n_cols - 1:
        nr, nc = r + 1, c - 1
    elif 5 <= r <= n_rows - 1 and 0 <= c <= 4:
        nr, nc = r - 1, c - 1
    else:
        return r, c

    nr = min(max(nr, 0), n_rows - 1)
    nc = min(max(nc, 0), n_cols - 1)
    return nr, nc

new_coords = [shift(r, c) for r, c in coords]
new_rows, new_cols = zip(*new_coords)

output = np.full((9, 9), np.nan)
for (r, c, v) in zip(new_rows, new_cols, values):
    output[r, c] = v

print(np.array_equal(output, test, equal_nan=True))