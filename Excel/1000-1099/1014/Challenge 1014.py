import pandas as pd
from itertools import groupby

path = "1000-1099/1014/1014 - Tokens Sorting.xlsx"
input = pd.read_excel(path, usecols="A", nrows=10, skiprows=0)
test = pd.read_excel(path, usecols="B", nrows=10, skiprows=0)


def encode_runs(text):
    runs = [(char, len(list(group))) for char, group in groupby(text)]
    return "-".join(
        f"{char}{length}" for char, length in sorted(runs, key=lambda x: -x[1])
    )


input["Output"] = input["Data"].map(encode_runs)

print(input["Output"].equals(test["Output"]))
# True
