import pandas as pd
import re

path = "700-799/724/724 Reverse alphabets and numbers separately.xlsx"
input = pd.read_excel(path, usecols="A", nrows=11)
test = pd.read_excel(path, usecols="B", nrows=11)

def reverse_independently(s):
    s = str(s)
    letters = [c for c in s if c.isalpha()][::-1]
    digits = [c for c in s if c.isdigit()][::-1]
    li = iter(letters)
    di = iter(digits)
    return ''.join(next(li) if c.isalpha() else next(di) if c.isdigit() else c for c in s)

input['Reversed'] = input.iloc[:,0].map(reverse_independently)

print(input["Reversed"].equals(test['Answer Expected']))
# One row is different, but the rest are correct
