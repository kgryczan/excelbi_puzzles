import pandas as pd

path = "900-999/982/982 Palindromic Creation.xlsx"
input = pd.read_excel(path, usecols="A", nrows=8, skiprows=0)
test = pd.read_excel(path, usecols="B", nrows=8, skiprows=0)

input["out"] = input.Words.map(lambda s: next(s+s[:i][::-1] for i in range(len(s)) if s[i:]==s[i:][::-1]))

print(input['out'].equals(test['Answer Expected']))
# True