import pandas as pd
import re

input = pd.read_excel("443 Birds Search.xlsx", header=None, skiprows=1, usecols="B:K")
list = pd.read_excel("443 Birds Search.xlsx", usecols="M:M", nrows = 7)
test = pd.read_excel("443 Birds Search.xlsx",  header=None, skiprows=1, usecols="O:X")
test.columns = input.columns

input_united = input.apply(lambda x: ''.join(x.dropna().astype(str)), axis=1)
search = input_united.apply(lambda x: re.search('|'.join(list['Birds']), x))
span = search.apply(lambda x: x.span() if x else None)

output = []
for i in range(len(span)):
    if span[i]:
        start = span[i][0]
        end = span[i][1]
        row = i
        for j in range(start, end):
            output.append((row, j))

input2 = input.copy()
for i in range(len(input2)):
    for j in range(len(input2.columns)):
        if (i,j) in output:
            pass
        else:
            input2.iloc[i,j] = 'x'

print(input2.equals(test))