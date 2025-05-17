import pandas as pd
import numpy as np
from itertools import accumulate

path = "700-799/717/717 Alignment.xlsx"
input = pd.read_excel(path, usecols="A", skiprows=1, nrows=18)
test = pd.read_excel(path, usecols="B:G", skiprows=1, nrows=5)

x = input.iloc[:, 0].tolist()

sizes = next(i+1 for i, s in enumerate(accumulate(range(1, len(x)+1))) if s >= len(x))

split_indices = np.repeat(range(sizes), range(1, sizes+1))[:len(x)]
splits = [[] for _ in range(sizes)]
for idx, val in zip(split_indices, x):
    splits[idx].append(val)

max_len = max(len(s) for s in splits)
result = pd.DataFrame({str(i+1): s + [np.nan]*(max_len - len(s)) for i, s in enumerate(splits)})

print(all(result) == all(test)) # True