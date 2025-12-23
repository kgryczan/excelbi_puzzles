import pandas as pd
import numpy as np
from itertools import groupby

df = pd.read_excel("Excel/800-899/874/874 Consecutive Characters Groups.xlsx", usecols=[0,1,2], skiprows=1, nrows=43, names=["Data","Number of Groups","Longest Group"])
test = df[["Number of Groups","Longest Group"]]
test.replace({np.nan: ""}, inplace=True)

def proc(s):
    if pd.isna(s): return 0, np.nan
    g = [(k, sum(1 for _ in grp)) for k, grp in groupby(s)]
    v = [(l, c) for l, c in g if c >= 2]
    if not v: return 0, np.nan
    m = max(c for _, c in v)
    return len(v), ", ".join(l*c for l, c in v if c == m)

out = df["Data"].apply(lambda x: pd.Series(proc(x)))
out.columns = ["Number of Groups","Longest Group"]
out = out.replace({np.nan: ""})

all(out == test)
