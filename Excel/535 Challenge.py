import pandas as pd
import numpy as np

path = "535 Generate Number Grid.xlsx"
height = pd.read_excel(path, usecols = "B", nrows = 1, header = None).values[0][0]
width = pd.read_excel(path, usecols = "B", nrows = 1, skiprows = 1, header = None).values[0][0]
test = pd.read_excel(path, usecols = "D:K", skiprows = 1, header = None).values

matrix = np.zeros((height, width), dtype=int)

for i in range(1, height + 1):
    matrix[i - 1, :] = np.roll(np.arange(1, width + 1), i - 1)

print(np.array_equal(matrix, test)) # True
