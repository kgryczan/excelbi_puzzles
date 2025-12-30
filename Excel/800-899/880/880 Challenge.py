import numpy as np

def layer_matrix(n):
    size = 2 * n - 1
    mat = np.fromfunction(lambda i, j: np.maximum(np.abs(i - (n - 1)), np.abs(j - (n - 1))) + 1, (size, size), dtype=int)
    return mat.astype(int)

print(layer_matrix(2))
print(layer_matrix(4))
print(layer_matrix(7))
