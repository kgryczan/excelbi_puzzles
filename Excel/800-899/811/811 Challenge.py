import pandas as pd
import numpy as np

path = "800-899/811/811 Dublicate Text, Dates and Divide Costs.xlsx"
input = pd.read_excel(path, usecols="A:H", skiprows=1, nrows=4)
test = pd.read_excel(path, usecols="J:Q", skiprows=1, nrows=11).rename(columns=lambda x: x.replace('.1', ''))

df = input.loc[input.index.repeat(input['Quantity'])].reset_index(drop=True)
df['Item'] = range(1, len(df) + 1)
df['Material Cost'] /= input.loc[input.index.repeat(input['Quantity']), 'Quantity'].values
df['Installation Cost'] /= input.loc[input.index.repeat(input['Quantity']), 'Quantity'].values
df['Quantity'] = 1
result = df[['Item', 'Code', 'Item Name', 'Location', 'Quantity', 'Material Cost', 'Installation Cost', 'Date']]
result = result.rename(columns={'Code': 'Item Code'})
totals = result.sum(numeric_only=True)
result.loc[len(result)] = [np.nan, np.nan, np.nan, 'Total', 
                           totals['Quantity'].astype('int64'), totals['Material Cost'].astype('int64'), 
                           totals['Installation Cost'].astype('int64'), pd.NaT]

# little bit different typing