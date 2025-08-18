import numpy as np
import pandas as pd

path = "700-799/784/784 Sum of Square.xlsx"
input_matrix = pd.read_excel(path, header=None, usecols="B:K", skiprows=1, nrows=10).values
test = pd.read_excel(path, usecols="M", nrows=1).values.flatten()

result = input_matrix.sum(axis=1).sum() \
    + input_matrix.sum(axis=0).sum() \
    + np.trace(input_matrix) \
    + np.trace(np.fliplr(input_matrix)) 

print(result == test) # True
