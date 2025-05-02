import pandas as pd

path = "PQ_Challenge_248.xlsx"
input = pd.read_excel(path, sheet_name=1, usecols="A:F", nrows=9)
test = pd.read_excel(path, sheet_name=1, usecols="A:I", skiprows=12, nrows=5)

input['Persons'].ffill(inplace=True)
input_long = input.melt(id_vars=['Persons', 'Category'], var_name='Quarter', value_name='Value')
input_long['Category_Quarter'] = input_long['Quarter'] + ' ' + input_long['Category']
result = input_long.pivot(index='Persons', columns='Category_Quarter', values='Value').reset_index()

result = result.sort_values(by='Q1 Sales', ascending=False)
result.update(result.filter(like='Q').sub(result.filter(like='Q').shift(-1, fill_value=0)))

result['Quarters'] = result['Persons'].str[-1]
zipped_columns = [val for pair in zip(sorted([col for col in result.columns if 'Sales' in col]), 
                                      sorted([col for col in result.columns if 'Bonus' in col])) for val in pair]

result = result[['Quarters'] + zipped_columns].sort_values(by='Quarters').reset_index(drop=True)
result.columns.name = None

print(result.equals(test)) # True