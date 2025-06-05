import pandas as pd

path = "700-799/732/732.xlsx"

input = pd.read_excel(path, usecols="A", skiprows=1, nrows=5, names=["Data"])
test = pd.read_excel(path, usecols="C:F", skiprows=1, nrows=6)
test['Value1'] = test['Value1'].astype('float64')

input_expanded = input['Data'].str.split(', ', expand=True).stack().reset_index(level=1, drop=True).to_frame('Data')
input_expanded.reset_index(drop=True, inplace=True)

input_expanded[['Alphabet', 'Value']] = input_expanded['Data'].str.split('-', expand=True)
input_expanded['Value'] = input_expanded['Value'].astype('int64')
input_expanded.drop(columns='Data', inplace=True)

input_expanded['rn'] = input_expanded.groupby('Alphabet').cumcount() + 1

result = input_expanded.pivot_table(index='Alphabet', columns='rn', values='Value', aggfunc='first')
result.columns = [f'Value{col}' for col in result.columns]
result = result.reset_index()

print(result.equals(test)) # True