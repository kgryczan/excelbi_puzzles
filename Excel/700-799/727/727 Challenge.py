import pandas as pd

path = "700-799/727/727 Remove Duplicates.xlsx"
input = pd.read_excel(path, usecols="A:C", skiprows=1, nrows=13)
test = pd.read_excel(path, usecols="E:G", skiprows=1, nrows=8).rename(columns=lambda col: col.replace('.1', ''))

result = input.groupby(['State','Stock'], as_index=False)['Amount'].last()
print(result.equals(test)) # True