import pandas as pd

path = "700-799/749/749 Portmanteau Words v2.xlsx"
input1 = pd.read_excel(path, usecols="A", nrows=10)
input2 = pd.read_excel(path, usecols="B:C", nrows=10)
test = pd.read_excel(path, usecols="D", nrows=5)

def get_all_substrings(x):
    if not isinstance(x, str) or not x:
        return []
    return list({x[:i] for i in range(1, len(x)+1)} | {x[i-1:] for i in range(len(x), 0, -1)})

ports = [
    word
    for _, row in input2.iterrows()
    for word in set(
        a + b
        for a in get_all_substrings(row['Word1'])
        for b in get_all_substrings(row['Word2'])
    ) & set(input1.iloc[:, 0])
]

result = pd.DataFrame({'port1': sorted(ports)})

print(test['Answer Expected'].equals(result['port1']))
# True 