import pandas as pd
import numpy as np

path = "555 Order Cities.xlsx"
input = pd.read_excel(path, usecols="A:E")
test  = pd.read_excel(path, usecols="G:K")

def transform(input_df):
    input_df['rn'] = np.arange(len(input_df)) + 1
    result = input_df.melt(id_vars=['rn'], var_name='key', value_name='value')

    def custom_sort(group):
        even_sort = group[group['rn'] % 2 == 0].sort_values(by='value', ascending=False)
        odd_sort = group[group['rn'] % 2 != 0].sort_values(by='value', ascending=True)
        return pd.concat([even_sort, odd_sort])

    result = result.groupby('rn').apply(custom_sort).reset_index(drop=True)
    result['rn2'] = result.groupby('rn').cumcount() + 1
    result['key'] = result['key'].where(result['value'].notna(), np.nan)
    result = result.pivot(index='rn', columns='rn2', values='key').reset_index(drop=True)

    return result

output = transform(input)
test.columns = output.columns

print(output.equals(test)) # True