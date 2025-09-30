import pandas as pd

path = "800-899/815/815 Unpivot.xlsx"
input = pd.read_excel(path, usecols="A:F", skiprows=1, nrows=7)
test = pd.read_excel(path, usecols="H:I", skiprows=1, nrows=10).rename(columns=lambda x: x.replace('.1', ''))

input['Product'] = input['Product'].ffill()
df = input.melt(id_vars=['Product', 'Data']).dropna(subset=['value'])
df = df.pivot_table(index=['Product', 'variable'], columns='Data', values='value').reset_index()
result = df.assign(Amount=(df['Price'] * df['Quantity']).astype(int))[['Product', 'Amount']]
result.columns.name = None

print(result.equals(test)) # True