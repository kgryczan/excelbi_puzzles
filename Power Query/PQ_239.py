import pandas as pd

path = "PQ_Challenge_239.xlsx"
input = pd.read_excel(path, usecols="A:E", nrows=3)
test = pd.read_excel(path, usecols="G:J", nrows=9).rename(columns=lambda x: x.split('.')[0])

input['rownumber'] = input.reset_index().index + 1
input_long = input.melt(id_vars=['Name', 'rownumber'], var_name='quarter', value_name='sales')

input_long['QtQ Drop'] = input_long.groupby('Name')['quarter'].shift(-1) + "-" + input_long['quarter']
input_long['Amount'] = input_long.groupby('Name')['sales'].shift(-1) - input_long['sales']
input_long['Rank'] = input_long.groupby('Name')['Amount'].transform('sum').rank(method='dense', ascending=False)

input_long = input_long.sort_values(by=['rownumber', 'quarter', "Rank"])

input_long.loc[input_long['quarter'] != 'Q1', ['Name', 'Rank']] = None

result = input_long.dropna(subset=['Amount']).loc[:, ['Name', 'QtQ Drop', 'Amount', 'Rank']].reset_index(drop=True)
result['Amount'] = result['Amount'].astype('int64')

print(result.equals(test)) # True