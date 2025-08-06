import pandas as pd
import re

path = "700-799/776/776 Stack.xlsx"

input = pd.read_excel(path, usecols="A:B", nrows=16)
test = "".join(pd.read_excel(path, usecols="D", nrows=27).iloc[:, 0].astype(str))

def extract_groups(series):
    return [m[0] for m in re.findall(r'((.)\2+|.)', "".join(series.dropna().astype(str)))]

result = "".join(a + b for a, b in zip(*(extract_groups(input.iloc[:, i]) for i in range(2))))

print(result == test) # True