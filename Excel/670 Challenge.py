import pandas as pd

path = "670 Transpose.xlsx"
input = pd.read_excel(path, sheet_name=0, usecols="A:C", skiprows=1, nrows=10)
test = pd.read_excel(path, sheet_name=0, usecols="E:I", skiprows=1, nrows=3).rename(columns=lambda x: x.split('.')[0])

input['Year'] = input.apply(lambda row: row['Detail'] if row['Classification'] == 'Year' else None, axis=1)
input['Year'] = input['Year'].ffill().astype('int64')
input = input[input['Classification'] != 'Year']
result = input.pivot(index=['Org','Year'], columns='Classification', values='Detail').reset_index()
result['Profit'] = result['Revenue'] - result['Cost']
result.columns.name = None
result = result[['Org', 'Year', 'Revenue', 'Cost', 'Profit']]

print(result.equals(test)) # True