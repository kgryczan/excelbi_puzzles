import pandas as pd

path = "638 Days of the Week Abbreviation.xlsx"
input = pd.read_excel(path, usecols="A:C", skiprows=1, nrows=8)
test = pd.read_excel(path, usecols="D:F", skiprows=1, nrows=8).rename(columns=lambda x: x.split('.')[0])

result = input.apply(lambda col: next(col.str[:i] for i in range(1, len(col[0]) + 1) if len(col.str[:i].unique()) == len(col)))

print(result.equals(test)) # True