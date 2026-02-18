import pandas as pd

path = "Excel/900-999/916/916 Burrows - Wheeler Data Transform.xlsx"
input = pd.read_excel(path, usecols="A", nrows=10)
test = pd.read_excel(path, usecols="B", nrows=10)

def bwt(s):
    rots = sorted(s[i:] + s[:i] for i in range(len(s)))
    return ''.join(r[-1] for r in rots)

input['BWT'] = input['Words'].apply(bwt)

print(input['BWT'].equals(test['Answer Expected']))