import pandas as pd

path = "606 Merge Rows.xlsx"
input = pd.read_excel(path, usecols="A:E", nrows=7)
test = pd.read_excel(path, usecols="A:E", skiprows=9, nrows=4).fillna("")

result = input.groupby('Name').agg(lambda x: ', '.join(sorted(x.dropna().astype(str)))).reset_index()
result = result.sort_values(by='Name')

print(result.equals(test)) # True