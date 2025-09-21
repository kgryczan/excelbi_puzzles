import pandas as pd
import numpy as np

path = "300-399/324/PQ_Challenge_324.xlsx"

input = pd.read_excel(path, usecols="A:B", nrows=22)
test = pd.read_excel(path, usecols="D:G", nrows=8).fillna(0)
test['South Avenue'] = test['South Avenue'].astype(int)

input['Store'] = input.loc[input['Data1'] == 'Store', 'Data2']
input['Store'] = input['Store'].ffill()
input['Visit Date'] = input.loc[input['Data1'] == 'Visit Date', 'Data2']
input['Visit Date'] = input['Visit Date'][::-1].ffill()[::-1]
mask = (input['Data2'] != input['Store']) & (input['Data2'] != input['Visit Date'])
df = input.loc[mask, ['Data2', 'Store']]
df = df.assign(Name=df['Data2'].str.split(', ')).explode('Name').drop(columns='Data2')
result = df.groupby(['Name', 'Store']).size().unstack(fill_value=0)
result.loc['Total'] = result.sum()
result['Total'] = result.sum(axis=1)
result = result.reset_index()
result.columns.name = None

print(result.equals(test))