import pandas as pd

path = "PQ_Challenge_264.xlsx"
input = pd.read_excel(path, usecols="A:E", nrows=7)
test = pd.read_excel(path,  usecols="A:F", skiprows=10, nrows=7)

input_long = input.melt(id_vars=input.columns[0], var_name="col", value_name="Alphabet").dropna()
input_long['Address'] = input_long[input.columns[0]].astype(str) + input_long['col']
input_long = input_long.sort_values(by=['Alphabet', 'Address'])
input_long['rn'] = input_long.groupby('Alphabet').cumcount() + 1

result = input_long.pivot(index='Alphabet', columns='rn', values='Address').reset_index()
result.columns = ['Alphabet'] + [f'Address{col}' for col in result.columns if col != 'Alphabet']

print(result.equals(test)) # True