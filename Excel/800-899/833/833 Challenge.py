import pandas as pd

path = "800-899/833/833 Summarize.xlsx"
input = pd.read_excel(path, usecols="A:C", skiprows=1, nrows=13)
test = pd.read_excel(path, usecols="E:H", skiprows=1, nrows=3).rename(columns=lambda col: col.replace('.1', ''))

input['Date'] = input.apply(lambda row: row['Data'] if pd.notna(row['Task']) else pd.NA, axis=1)
input['Date'] = input['Date'].fillna(method='ffill')
input['Task'] = input['Task'].fillna(method='ffill')
filtered = input[input['Data'] != input['Date']]

result = (
    filtered
    .groupby(['Store', 'Date', 'Task'], as_index=False)
    .agg(Amount=('Data', lambda x: x.sum(skipna=True)))
)
print(result.equals(test)) # True