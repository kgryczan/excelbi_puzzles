import pandas as pd

path = "607 Sort Odd Numbers First.xlsx"
input = pd.read_excel(path, usecols="A:C", skiprows=1, nrows=15)
test = pd.read_excel(path, usecols="E:G", skiprows=1, nrows=15).rename(columns=lambda col: col.split('.')[0])

sorted_input = input.apply(lambda col: sorted(col, key=lambda x: (-(x % 2), x)))

print(sorted_input.equals(test)) # True