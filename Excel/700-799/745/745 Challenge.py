import pandas as pd

path = "700-799/745/745 Financial Pivot.xlsx"
input = pd.read_excel(path, usecols="A:D", skiprows=1, nrows=15)
test = pd.read_excel(path, usecols="F:I", skiprows=1, nrows=4).rename(columns=lambda c: c.replace('.1', ''))

input['Company'] = input['Company'].ffill()
result = input.groupby('Company', as_index=False)[['Revenue', 'Cost']].sum()
result.columns = ['Company', 'Total Revenue', 'Total Cost']
result['Total Profit'] = result['Total Revenue'] - result['Total Cost']
result = result.sort_values('Total Profit', ascending=True, ignore_index=True)
result.loc[len(result)] = ['Grand Total'] + result.iloc[:, 1:].sum().tolist()

print(result.equals(test)) # True