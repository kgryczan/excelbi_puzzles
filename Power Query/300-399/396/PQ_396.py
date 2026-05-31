import pandas as pd
from functools import reduce
path = "300-399/396/PQ_Challenge_396.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=32)
test = pd.read_excel(path, usecols="E:F", nrows=3).rename(columns=lambda c: c.replace('.1', ''))

tokens = reduce(
    lambda acc, y: acc[:-1] if len(acc) > 0 and acc[-1] == y else acc + [y],
    input["Token"],
    []
)
result = input[input["Token"].isin(tokens)].reset_index(drop=True)
print(result.equals(test))
# True