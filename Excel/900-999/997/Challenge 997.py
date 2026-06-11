import pandas as pd
import numpy as np
import string

path = "900-999/997/997 Square Spiral.xlsx"
test = pd.read_excel(
    path, usecols="B:G", nrows=6, skiprows=1, header=None, dtype=str
).to_numpy()

x = np.array(list(string.ascii_uppercase + "0123456789"))
idx = np.arange(36).reshape(6, 6)
out = np.empty(36, object)
while idx.size:
    out[idx[0]], x, idx = x[: idx.shape[1]], x[idx.shape[1] :], np.rot90(idx[1:])
result = out.reshape(6, 6)

print(np.array_equal(result, test))
# True
