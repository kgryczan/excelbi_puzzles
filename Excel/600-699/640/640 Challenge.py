import pandas as pd

path = "640 Sum Between Two Pluses.xlsx"
input = pd.read_excel(path, usecols="A", skiprows=1, nrows=20)
test = pd.read_excel(path, usecols="C:D", skiprows=1, nrows=6)

input['Group'] = (input['Data'] == '+').cumsum().astype('int64')
filtered = input[input['Data'] != '+']
result = filtered.groupby('Group').agg({'Data': lambda x: x.astype(float).sum()}).reset_index()    
result.columns = ['Group', 'Sum']
result['Sum'] = result['Sum'].astype('int64')

print(result.equals(test)) # True