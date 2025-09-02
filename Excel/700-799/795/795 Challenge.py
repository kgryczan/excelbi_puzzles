import pandas as pd

path = "700-799/795/795 Summarize.xlsx"
input = pd.read_excel(path, usecols="A:C", skiprows=1, nrows=8, dtype=str)
test = pd.read_excel(path, usecols="E:G", skiprows=1, nrows=4, dtype=str).rename(columns=lambda col: col.replace('.1', ''))

result = input.ffill().groupby('Supplier', as_index=False).agg({'Items': ' - '.join, 'Cost': ' - '.join})

print(result.equals(test)) # True