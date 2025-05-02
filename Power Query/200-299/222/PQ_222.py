import pandas as pd
import numpy as np

path = "PQ_Challenge_222.xlsx"
input = pd.read_excel(path, usecols="A:I", nrows=7)
test = pd.read_excel(path, usecols="A:D", skiprows=10, nrows=7)

input_long = input.melt(id_vars='Student', var_name='variable', value_name='Marks')

first_part = input_long[input_long['variable'].str.contains('Test')]
second_part = input_long[input_long['variable'].str.contains('Marks')].reset_index(drop=True).add_suffix('_2')

output = pd.concat([first_part, second_part], axis=1).drop(columns=['variable', 'variable_2', 'Student_2'])
output = output.rename(columns={'Marks': 'Subjects', 'Marks_2': 'Marks'}).dropna()
output['Marks'] = pd.to_numeric(output['Marks'], errors='coerce')
output['Rank'] = output.groupby('Subjects')['Marks'].rank(ascending=False, method='first').astype(int)
output = output.sort_values(['Subjects', 'Rank']).reset_index(drop=True)
output['Student'] = output['Student'] + ' ' + output['Marks'].astype(str)
output = output.drop(columns='Marks')

output = output.pivot(index='Subjects', columns='Rank', values='Student').reset_index()
output.columns = ['Subjects'] + [f'Student{i}' for i in range(1, len(output.columns))]

for col in output.columns[1:]:
    output[col] = np.where(output[col].notnull() & (output[col].str.split().str[-1].astype(float) >= 40),
                           output[col].str.split().str[:-1].str.join(' '), 
                           np.nan)

output = output.dropna(axis=1, how='all')

print(output.equals(test))  # True
