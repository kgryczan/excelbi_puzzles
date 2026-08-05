from fnmatch import fnmatchcase

import pandas as pd

p = "1000-1099/1035/1035 Lookup.xlsx"
lookup_table = pd.read_excel(p, usecols="A:B").dropna()
input_table = pd.read_excel(p, usecols="D:F")


def lookup(account):
    matches = lookup_table[
        lookup_table.Pattern.map(lambda pattern: fnmatchcase(account, pattern))
    ]
    return matches.loc[matches.Pattern.str.len().idxmax(), "Global_Account"]


input_table["Result"] = input_table.Local_Acc.map(lookup)
print(input_table.Result.eq(input_table["Answer Expected"]).all())
