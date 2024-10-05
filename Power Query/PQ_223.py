import pandas as pd

path = "PQ_Challenge_223.xlsx"
input = pd.read_excel(path, usecols="A:D", nrows=14, dtype={'Group': str, 'Type': str, 'Code': str, 'Value': int})
test = pd.read_excel(path, usecols="F:J", nrows=7).rename(columns=lambda x: x.replace('.1', '')).replace('NA', pd.NA)
test[['Value1', 'Value2']] = test[['Value1', 'Value2']].astype('Int64')

input['Code'] = input['Type'] + input['Code']
input = input.drop(columns=['Type'])
input['col'] = input.groupby('Group').cumcount().mod(2).add(1)
input['row'] = input.groupby('Group').cumcount().floordiv(2).add(1)

result = input.pivot(index=['Group', 'row'], columns='col', values=['Code', 'Value'])
result.columns = [f'{col[0]}{col[1]}' for col in result.columns]
result = result.reset_index().drop(columns=['row'])
result[['Value1', 'Value2']] = result[['Value1', 'Value2']].astype('Int64')

print(result.equals(test)) # True
