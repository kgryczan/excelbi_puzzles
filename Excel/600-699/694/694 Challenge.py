import pandas as pd
from itertools import groupby

path = "694 Repeat Characters Except Consecutives.xlsx"
input = pd.read_excel(path, usecols="A", nrows=9)
test = pd.read_excel(path, usecols="B", nrows=9)

def double_single_chars(s):
    return ''.join(g*2 if len(g)==1 else g for g in (''.join(list(grp)) for _, grp in groupby(s)))

input["Transformed"] = input["Data"].apply(double_single_chars)

print(input['Transformed'] == test['Answer Expected'])