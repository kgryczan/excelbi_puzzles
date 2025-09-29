import pandas as pd

path = "800-899/814/814 Increasing Alphabets.xlsx"
input = pd.read_excel(path, usecols="A", nrows=10)
test = pd.read_excel(path, usecols="B", nrows=10).fillna({"Answer Expected": ""})

def split_increasing(s):
    chars = list(str(s))
    idx = [0]
    for i in range(1, len(chars)):
        idx.append(idx[-1] + (ord(chars[i]) <= ord(chars[i-1])))
    groups = {}
    for i, g in enumerate(idx):
        groups.setdefault(g, []).append(chars[i])
    return ', '.join(''.join(g) for g in groups.values() if len(g) >= 2)

input['Answer Expected'] = input.iloc[:,0].apply(split_increasing)
print(input["Answer Expected"].equals(test["Answer Expected"])) # TRUE