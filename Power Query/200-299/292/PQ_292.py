import pandas as pd

path = "200-299/292/PQ_Challenge_292.xlsx"
input = pd.read_excel(path, sheet_name=0, usecols="A:K", nrows=4)
test = pd.read_excel(path, sheet_name=0, usecols="A:F", skiprows=7, nrows=7)

df = input.melt(id_vars=input.columns[:2], var_name='name', value_name='value')
df[['name', 'Item']] = df['name'].str.split('-', expand=True)
df['Item'] = df['Item'].ffill()
df['name'] = df['name'].str.replace(r'\.{1}\d{1,2}', '', regex=True)
df_wide = df.pivot_table(index=['Customer', 'Org', 'Item'], columns='name', values='value', fill_value=0).reset_index()
df_wide = df_wide.astype({col: 'int' for col in df_wide.columns if col not in ['Customer', 'Org', 'Item']})
df_wide = df_wide.sort_values(['Item', 'Customer'], ascending=[True, False]).reset_index(drop=True)
df_wide.columns.name = None
df_wide['Item Total'] = df_wide.get('ItemA', 0) + df_wide.get('ItemB', 0) + df_wide.get('ItemC', 0)
result = df_wide[['Customer', 'Org', 'Item', 'Item Total', 'Credit', 'Debit']]

print(result.equals(test)) # True