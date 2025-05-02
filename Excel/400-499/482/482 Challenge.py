import pandas as pd

path = '482 Soccer Result Grid.xlsx'
input = pd.read_excel(path, usecols="A:C", skiprows=1, nrows=10)
test = pd.read_excel(path, usecols="E:J", skiprows=1, nrows=5)

rev_input = input.copy()
rev_input = input.copy()
rev_input['Team 1'], rev_input['Team 2'] = input['Team 2'], input['Team 1']
rev_input['Result'] = input['Result'].str.split('-').str[::-1].str.join('-')


result = pd.concat([input, rev_input], ignore_index=True)
result = result.pivot(index='Team 1', columns='Team 2', values='Result')\
    .fillna('X')\
    .reset_index()\
    .rename(columns={'Team 1': 'Team'})
result.columns.name = None

print(result.equals(test)) # True