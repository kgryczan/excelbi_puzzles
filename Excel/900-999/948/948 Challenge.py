import pandas as pd
import re

path = "900-999/948/948 Remove Pairs.xlsx"
input = pd.read_excel(path, usecols="A", nrows=15, skiprows=0, dtype=str)
test = pd.read_excel(path, usecols="B", nrows=15, skiprows=0, dtype=str)
test["Answer Expected"] = test["Answer Expected"].fillna("")


def remove_pairs(s):
    while True:
        new = re.sub(r'(.)\1', '', s)
        if new == s:
            return s
        s = new

input["Answer Expected"] = input["Data"].apply(remove_pairs)

print(input['Answer Expected'].equals(test['Answer Expected']))
# True