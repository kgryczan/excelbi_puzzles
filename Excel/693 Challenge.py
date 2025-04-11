import pandas as pd

path = "693 Generate a sequence.xlsx"
test = pd.read_excel(path, usecols="A", nrows=101)

start = [1, 2, 3, 4]
while len(start) < 101:
    start += [start[-4] + start[-2], start[-3] + start[-1]]
start = start[:100]
df = pd.DataFrame({'Sequence': start})

print(df["Sequence"].equals(test["Answer Expected"])) # True
