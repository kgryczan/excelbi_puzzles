import pandas as pd
import re
from itertools import accumulate

path = "900-999/975/975 Active Brackets Weighted Sum.xlsx"
input = pd.read_excel(path, usecols="A", nrows=21, skiprows=0)
test = pd.read_excel(path, usecols="B", nrows=21, skiprows=0)

def solve(s):
    weight = {
        "(": 1, "[": 2, "{": 3,
        ")": -1, "]": -2, "}": -3
    }
    tokens = re.findall(r"\d+|[()[\]{}]", s)
    active = accumulate(weight.get(t, 0) for t in tokens)
    return sum(
        int(t) * a
        for t, a in zip(tokens, active)
        if t.isdigit()
    )
input["Answer Expected"] = input["Data"].apply(solve)

print(input['Answer Expected'].equals(test['Answer Expected']))
# True