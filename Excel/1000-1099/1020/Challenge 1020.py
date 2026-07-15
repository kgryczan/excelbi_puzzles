import pandas as pd
from itertools import accumulate
import numpy as np

path = "1000-1099/1020/1020 Running Total with Condition.xlsx"
input = pd.read_excel(path, usecols="A", nrows=20)
test = pd.read_excel(path, usecols="B", nrows=20)


def running_total(s):
    def step(state, x):
        total, flip = state
        if x == "FLIP":
            return total, not flip
        if x == "RESET":
            return 0, False
        x = float(x)
        return (max(0, total - x), flip) if flip else (total + x, flip)

    return np.array(
        [
            total
            for total, _ in list(accumulate(s, step, initial=(np.int64(0), False)))[1:]
        ],
        dtype=np.int64,
    )


result = running_total(input["Signal"]).astype("int64")
print((result == test["Answer Expected"]).all())
# True
