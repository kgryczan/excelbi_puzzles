import pandas as pd
import numpy as np

path = "300-399/336/PQ_Challenge_336.xlsx"
input = pd.read_excel(path, usecols="A:I", nrows=5)
test = pd.read_excel(path, usecols="A:F", skiprows=8, nrows=9)
input_long = input.melt(id_vars='Persons', var_name='Category_Quarter', value_name='value')
input_long[['Category', 'Quarter']] = input_long['Category_Quarter'].str.split('-', expand=True)

input_long['value'] = input_long.groupby(['Category', 'Quarter'])['value'].cumsum()
def accumulate_persons(persons):
    acc = ""
    return [acc := p if not acc else f"{acc} & {p}" for p in persons]
input_long['Persons'] = input_long.groupby(['Category', 'Quarter'])['Persons'].transform(accumulate_persons)
result = (input_long.pivot_table(index=['Persons', 'Category'], columns='Quarter', values='value')
          .reset_index()
          .sort_values(['Persons', 'Category'], ascending=[True, False])
          .reset_index(drop=True))
result.loc[result['Category'] == 'Bonus', 'Persons'] = np.nan
for col in result.columns:
    if str(col).startswith('Q'):
        result[col] = result[col].astype('int64')
result.columns.name = None

print(result.equals(test)) # True