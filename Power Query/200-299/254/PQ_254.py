import pandas as pd

path = "PQ_Challenge_254.xlsx"
input = pd.read_excel(path, usecols="A:Q", nrows=5)
test = pd.read_excel(path, usecols="A:C", skiprows=8, nrows=11).sort_values("Dept").reset_index(drop=True)

input_long = pd.melt(input, id_vars=[input.columns[0]], var_name='Variable', value_name='Value')
input_long[['Name', 'Number']] = input_long['Variable'].str.extract(r'([a-zA-Z]+)(\d+)')
input_long.drop(columns=['Variable'], inplace=True)
input_long.dropna(subset=['Value'], inplace=True)
input_long.loc[input_long['Name'].isin(['Salary', 'Age']), 'Value'] = input_long.loc[input_long['Name'].isin(['Salary', 'Age']), 'Value'].astype(int)
input_pivot = input_long.pivot_table(index=['Dept', 'Number'], columns='Name', values='Value', aggfunc='first').reset_index()
input_pivot['Age & Nationality & Salary'] = input_pivot[['Age', 'Nationality', 'Salary']].astype(str).agg(', '.join, axis=1)
input_pivot.drop(columns=['Number', 'Age', 'Nationality', 'Salary'], inplace=True)
input_pivot = input_pivot.rename_axis(None, axis=1)

print(input_pivot.equals(test)) # True