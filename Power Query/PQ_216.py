import pandas as pd

path = "PQ_Challenge_216.xlsx"
input = pd.read_excel(path, usecols="A:E", nrows=5)
test  = pd.read_excel(path, usecols="A:E", skiprows=10, nrows=5)

result = input.melt(var_name='Column', value_name='Item')
result['Column'] = result['Column'].str.replace('Column', '')
result['item_n'] = result['Item'].str.extract(r'(\d+)', expand=False).astype('Int64')

result['rn'] = result.groupby('Column').cumcount() + 1
result['Column_label'] = result.groupby('rn')['item_n'].transform(lambda x: f"Items {x.min()} - {x.max()}")

result = result.pivot(index='Column', columns='Column_label', values='Item').reset_index(drop=True)result = result[['Items 1 - 4', 'Items 5 - 9', 'Items 10 - 11', 'Items 12 - 14', 'Items 15 - 15']]
