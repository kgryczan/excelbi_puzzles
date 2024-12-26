import pandas as pd
import numpy as np

path = "616 Draw a Christmas Tree.xlsx"
test = pd.read_excel(path, header=None, usecols="A:O", nrows=19).fillna("").values

M = np.full((19, 15), "", dtype=object)

middle = M.shape[1] // 2

M[0, middle] = "*"
for i in range(1, 8):
    M[i, [middle - i, middle + i]] = "*"
M[7, :] = "*"

M[8, middle] = "*"
for i in range(9, 16):
    M[i, [middle - (i - 8), middle + (i - 8)]] = "*"
M[15, :] = "*"
M[16, [middle - 1, middle + 1]] = "|"
M[17, middle - 2:middle + 3] = "-"

M[18, [middle - 3, middle + 3]] = ["/", "\\"]
M[18, middle - 2:middle + 3] = "_"

M[1, middle] = "1"
M[9, middle] = "1"

[M.__setitem__((i, [middle - i + 1, middle + i - 1]), "1") for i in range(2, 7)]
[M.__setitem__((i, [middle - (i - 9), middle + (i - 9)]), "1") for i in range(10, 15)]

[M.__setitem__((i, [middle - i + 2, middle + i - 2]), "2") for i in range(2, 7)]
[M.__setitem__((i, [middle - (i - 10), middle + (i - 10)]), "2") for i in range(10, 15)]

[M.__setitem__((i, [middle - i + 3, middle + i - 3]), "3") for i in range(3, 7)]
[M.__setitem__((i, [middle - (i - 11), middle + (i - 11)]), "3") for i in range(11, 15)]

[M.__setitem__((i, [middle - i + 4, middle + i - 4]), "4") for i in range(4, 7)]
[M.__setitem__((i, [middle - (i - 12), middle + (i - 12)]), "4") for i in range(12, 15)]

[M.__setitem__((i, middle - i + 5), "5") or M.__setitem__((i, middle + i - 5), "5") for i in range(5, 7)]
[M.__setitem__((i, middle - (i - 13)), "5") or M.__setitem__((i, middle + (i - 13)), "5") for i in range(13, 15)]

[M.__setitem__((i, middle - i + 6), "6") or M.__setitem__((i, middle + i - 6), "6") for i in range(6, 7)]
[M.__setitem__((i, middle - (i - 14)), "6") or M.__setitem__((i, middle + (i - 14)), "6") for i in range(14, 15)]


