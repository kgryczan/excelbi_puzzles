import pandas as pd
import re

path = "Excel/800-899/846/846 Circular Number Replacements.xlsx"
input = pd.read_excel(path, usecols="A", nrows=10)
test = pd.read_excel(path, usecols="B", nrows=10)

def shift_digits(s):
    m = re.findall(r"\d+", str(s))
    if not m:
        return s
    p = re.split(r"\d+", str(s))
    return "".join(a + b for a, b in zip(p, m[1:] + m[:1] + [""]))
input["shifted"] = input.iloc[:, 0].apply(shift_digits)

print(input["shifted"].equals(test.iloc[:, 0])) # True
