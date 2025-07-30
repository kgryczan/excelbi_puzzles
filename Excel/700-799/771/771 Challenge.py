import pandas as pd
import numpy as np
import math

path = "700-799/771/771 Split and Align.xlsx"
input = pd.read_excel(path, usecols="A", nrows=10)
test = pd.read_excel(path, usecols="B", nrows=46)

def cut_progressive_chunks(x):
    if pd.isna(x) or not isinstance(x, str):
        return []
    n = len(x)
    k = int((math.isqrt(1 + 8 * n) - 1) // 2)
    lengths = np.arange(1, k + 1)
    starts = np.cumsum(np.concatenate(([1], lengths[:-1])))
    ends = np.cumsum(lengths)
    return [x[s-1:e] for s, e in zip(starts, ends)]

input['chunks'] = input.iloc[:, 0].apply(cut_progressive_chunks)
result = input.explode('chunks', ignore_index=True)

print(result['chunks'].equals(test['Answer Expected'])) # True