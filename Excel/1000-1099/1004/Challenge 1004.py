import pandas as pd
import re

path = "1000-1099/1004/1004 Repititions.xlsx"
input = pd.read_excel(path, usecols="A", nrows=20, skiprows=0)
test = pd.read_excel(path, usecols="B", nrows=20, skiprows=0)


def expand(s):
    while "(" in s:
        s = re.sub(r"(\d*)\(([^()]*)\)", lambda m: m.group(2) * int(m.group(1) or 1), s)
    return s


input["expanded"] = input["Expression"].apply(expand)
print(input["expanded"].equals(test["Answer Expected"]))
## [1] TRUE
