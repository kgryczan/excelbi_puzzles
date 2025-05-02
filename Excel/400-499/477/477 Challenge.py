import pandas as pd
import numpy as np

input = pd.read_excel("477 Records Split and Alignment.xlsx", skiprows=1, usecols="A:B", nrows=14)
test = pd.read_excel("477 Records Split and Alignment.xlsx", skiprows=1, usecols="D:M", nrows=4)
test.columns = test.columns.str.replace("\\.+\\d+", "", regex=True)

nr = input.shape[0]

seq = []
i = 1
while sum(seq) <= nr:
    seq.append(i)
    i += 1

dfs = []
for i in range(len(seq)):
    if i == 0:
        dfs.append(input.iloc[:seq[i], :])
    else:
        dfs.append(input.iloc[sum(seq[:i]):sum(seq[:i+1]), :])

for i in range(len(dfs)):
    dfs[i].reset_index(drop=True, inplace=True)

df = pd.concat(dfs, axis=1)

print(df.equals(test)) # True

