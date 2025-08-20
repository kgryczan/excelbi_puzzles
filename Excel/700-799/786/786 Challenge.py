import pandas as pd
import re

path = "700-799/786/786 Sum of Items.xlsx"
input = pd.read_excel(path, usecols="A", skiprows=1, nrows=8)
test = pd.read_excel(path, usecols="B:C", skiprows=1, nrows=5).sort_values(by='Items').reset_index(drop=True)

input_long = input['Data'].dropna().str.split(' / ').explode().reset_index(drop=True)
df = input_long.str.extract(
    r'(?:(?P<Quantity>\d+)\s*(?P<Item>[A-Za-z]+)|(?P<Item2>[A-Za-z]+)\s*(?P<Quantity2>\d+))'
)
df['Item'] = df['Item'].combine_first(df['Item2'])
df['Quantity'] = df['Quantity'].combine_first(df['Quantity2'])
df = df[['Quantity', 'Item']]
df['Items'] = df['Item'].str.rstrip('s').fillna('')
df['Quantity'] = pd.to_numeric(df['Quantity'], errors='coerce')
result = (
    df.groupby('Items', as_index=False)['Quantity']
    .sum()
    .rename(columns={'Quantity': 'Total'})
    .sort_values(by='Items')
    .reset_index(drop=True)
)

print(result.equals(test)) # True