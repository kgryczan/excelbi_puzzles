import pandas as pd

path = "PQ_Challenge_232.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=6)
test = pd.read_excel(path, usecols="E:G", nrows=13).rename(columns=lambda x: x.split('.')[0])

input['Date'] = pd.to_datetime(input['Date'])
input['max_date'] = input.groupby('Store')['Date'].transform('max')
input['min_date'] = input.groupby('Store')['Date'].transform('min')

date_range = pd.date_range(input['Date'].min(), input['Date'].max(), freq='D')
complete = pd.MultiIndex.from_product([input['Store'].unique(), date_range], names=['Store', 'Date']).to_frame(index=False)

result = complete.merge(input, on=['Store', 'Date'], how='left')
result[['max_date', 'min_date']] = result.groupby('Store')[['max_date', 'min_date']].ffill()
result = result.query('min_date <= Date <= max_date')
result['Quantity_has_value'] = result['Quantity'].isna().apply(lambda x: not x)
result['Cumulative'] = result.groupby('Store')['Quantity_has_value'].cumsum()
result['Quantity'] = result.groupby('Store')['Quantity'].ffill()
result['Quantity'] = result.groupby(['Store', 'Cumulative'])['Quantity'].cumsum().astype('int64')
result = result[['Store', 'Date', 'Quantity']].reset_index(drop=True)

print(result.equals(test)) # True