from functools import lru_cache
import pandas as pd

path = "485 Pandovan Sequence.xlsx"
input = pd.read_excel(path, usecols="A")
test  = pd.read_excel(path, usecols="B")

@lru_cache(maxsize=None)
def padovan(n):
    if n <= 2:
        return 1
    else:
        return padovan(n - 2) + padovan(n - 3)

input["Pandovan"] = input["n"].apply(padovan)
print(input["Pandovan"].equals(test["Answer Expectecd"])) # True