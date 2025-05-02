import math
import numpy as np
import pandas as pd

def extract_antidiagonals(matrix_size):
    dim = int(math.sqrt(matrix_size))
    M = np.arange(1, matrix_size+1).reshape(dim, dim)
    diags = [M[::-1,:].diagonal(i) for i in range(-M.shape[0]+1,M.shape[1])]
    for diag in diags:
            print(diag)

extract_antidiagonals(4)
print("\n")
extract_antidiagonals(9)
print("\n")
extract_antidiagonals(16)
print("\n")
extract_antidiagonals(25)
