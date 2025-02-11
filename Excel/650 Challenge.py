import pandas as pd
path = "650 Top 3 Across Columns.xlsx"
input = pd.read_excel(path, usecols="A:E", nrows=15)
test = pd.read_excel(path, usecols="G", nrows=5).values.flatten().tolist()

result = input.apply(lambda col: ', '.join(map(str, sorted(col.dropna().astype(int).unique())[:3]))).tolist()

print(result == test) # True
