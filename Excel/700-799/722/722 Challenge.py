import pandas as pd

path = "700-799/722/722 Remove the Minimum Row.xlsx"
input = pd.read_excel(path, usecols="A:B", skiprows=1, nrows=11)
test = pd.read_excel(path, usecols="D:E", skiprows=1, nrows=6).rename(columns=lambda col: col.replace('.1', ''))

filtered = input.drop(input.groupby('Product')['Amount'].idxmin()).reset_index(drop=True)

print(filtered.equals(test)) # True