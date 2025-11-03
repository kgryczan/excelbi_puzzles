import pandas as pd
import numpy as np

path = "800-899/839/839 List Unique Across Columns.xlsx"
input = pd.read_excel(path, header=None, usecols="A:E", skiprows=1, nrows=8)
test = pd.read_excel(path, header=None, usecols="G:K", skiprows=1, nrows=4)

def accumulate_uniques(cols):
    res, seen = [], set()
    for col in cols:
        new = [x for x in pd.Series(col).dropna().unique() if x not in seen]
        seen.update(new)
        res.append(new)
    maxlen = max(map(len, res))
    return [r + [np.nan] * (maxlen - len(r)) for r in res]

result_cols = accumulate_uniques([input[col] for col in input.columns])
result = pd.DataFrame(result_cols).transpose()
result.columns = test.columns

print(result.equals(test)) # True