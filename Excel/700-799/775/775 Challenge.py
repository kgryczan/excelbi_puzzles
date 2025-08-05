import pandas as pd

path = "700-799/775/775 Pivot.xlsx"
input = pd.read_excel(path, usecols="A:B", skiprows=1, nrows=13)
test  = pd.read_excel(path, usecols="D:F", skiprows=1, nrows=6)

input['group'] = (input['Value1'] == "Org").cumsum()
input['row'] = input.groupby('group').cumcount() + 1
result = input.pivot(index=['group','row'], columns='Value1', values='Value2').reset_index()
result['Org'] = result['Org'].ffill()
result['Product'] = result.groupby('Org')['Product'].ffill()
result[['Version','Product']] = result.groupby('Org')[['Version','Product']].bfill()
result = result.drop(columns=['group', 'row'])
result = result.drop_duplicates().reset_index(drop=True)

print(result.equals(test)) # True