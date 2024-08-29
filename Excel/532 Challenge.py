import pandas as pd
import numpy as np

path = "532 Grid where each is sum of already filled in surrounding cells.xlsx"
test = pd.read_excel(path, usecols="B:K", skiprows =1 , header=None).values

matrix_size = 10
m = np.zeros((matrix_size, matrix_size))
m[0, 0] = 1

for i in range(matrix_size):
    for j in range(matrix_size):
        if i != 0 or j != 0:
            m[i, j] = np.sum(m[max(i-1, 0):min(i+2, matrix_size),
                               max(j-1, 0):min(j+2, matrix_size)])

print(np.array_equal(m, test))  # True
