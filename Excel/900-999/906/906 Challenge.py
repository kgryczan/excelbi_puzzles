import pandas as pd
import re

path = "Excel/900-999/906/906 Position Swapping.xlsx"
input = pd.read_excel(path, usecols="A", nrows=10)
test = pd.read_excel(path, usecols="B", nrows=10)

def rev_mix(x):
    s = list(x)
    l_pos, d_pos = [m.start() for m in re.finditer(r'[A-Za-z]', x)], [m.start() for m in re.finditer(r'\d', x)]
    for pos, char in zip(l_pos, [s[i] for i in l_pos][::-1]):
        s[pos] = char
    for pos, char in zip(d_pos, [s[i] for i in d_pos][::-1]):
        s[pos] = char
    return ''.join(s)

result = input['String'].map(rev_mix)
print(result.equals(test['Answer Expected']))
# True