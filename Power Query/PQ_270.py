import pandas as pd
import numpy as np

path = "PQ_Challenge_270.xlsx"
input = pd.read_excel(path, usecols="A:D", nrows=11).values
test = pd.read_excel(path, usecols="F:I", nrows=11).values

output_matrix = np.array([input[i, (np.arange(input.shape[1]) + i) % input.shape[1]] for i in range(input.shape[0])])

print(np.allclose(output_matrix, test)) # True