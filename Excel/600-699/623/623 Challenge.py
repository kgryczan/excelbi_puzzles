import pandas as pd
import numpy as np

path = "623 Sum of Numbers Across Diagonals of 3 Columns.xlsx"
input_data = pd.read_excel(path, usecols="A:C", nrows=19).values
test = pd.read_excel(path, usecols="E", nrows=1).squeeze()

def construct_zigzag(n, width=3):
    return np.tile(np.concatenate([np.arange(1, width + 1), np.arange(width - 1, 1, -1)]), n)[:n]

zigzag = construct_zigzag(len(input_data))
result = np.sum(input_data[np.arange(len(input_data)), zigzag - 1])

print(result == test) # True