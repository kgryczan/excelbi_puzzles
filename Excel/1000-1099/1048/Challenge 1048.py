import re
from functools import reduce

import pandas as pd

path = "1000-1099/1048/1048 Replace X With Sum of Digits.xlsx"
input = pd.read_excel(path, usecols="A", nrows=10)
test = pd.read_excel(path, usecols="B", nrows=10, dtype="str")


def replace_x(x):
    return reduce(
        lambda s, _: re.sub(
            "X",
            lambda m: str(
                int(re.findall(r"\d", s[: m.start()])[-1])
                + int(re.search(r"\d", s[m.end() :]).group())
            ),
            s,
            1,
        ),
        range(x.count("X")),
        x,
    )


input["Data"] = input["Data"].map(replace_x)
print(input["Data"].equals(test["Answer Expected"]))
# True
