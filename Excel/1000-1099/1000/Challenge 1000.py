import pandas as pd

path = "1000-1099/1000/1000 Count 2 Words Only Names.xlsx"
input = pd.read_excel(path, usecols="A", nrows=20)
test = pd.read_excel(path, usecols="B", nrows=1).squeeze()

result = input.iloc[:, 0].str.count(r"\w+").eq(2).sum()

print(result == test)  # True
