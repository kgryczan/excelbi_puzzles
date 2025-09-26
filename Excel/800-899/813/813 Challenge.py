import numpy as np

size = 8
M = np.full((2 * size + 1, 2 * size + 1), np.nan, dtype=float)

M[size, :] = np.arange(-size, size + 1)
M[:, size] = np.concatenate((np.arange(size, 0, -1), [0], np.arange(-1, -size - 1, -1)))

idx = np.argwhere(np.isnan(M))

for i, j in idx:
    if i + j == size or i - j == size:
        M[i, j] = -size
    elif i + j == 3 * size or j - i == size:
        M[i, j] = size

print(M)
