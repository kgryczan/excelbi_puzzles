import pandas as pd
import numpy as np
from itertools import product

path = "300-399/301/PQ_Challenge_301.xlsx"
input = pd.read_excel(path, usecols="A:E", nrows=9)
test = pd.read_excel(path, usecols="G:I", nrows=21)

input['type'] = np.where(input['Col1'].str.contains(r'\d'), 'Value', 'Text')
input['cumsum'] = input['type'].eq('Text').cumsum()

result = (
    input.melt(id_vars=['type', 'cumsum'], var_name='Column', value_name='Value')
    .groupby(['cumsum', 'Column', 'type'], as_index=False).first()
    .pivot(index=['cumsum', 'Column'], columns='type', values='Value')
    .reset_index().drop(columns='Column').dropna()
    .assign(Combined=lambda df: df['Text'] + '-' + df['Value'].astype(str))
    .groupby('cumsum', group_keys=False)
    .apply(lambda g: pd.DataFrame(
        [(x, y) for x, y in product(g['Combined'], repeat=2) if x < y],
        columns=['Var1', 'Var2']
    ))
    .reset_index(drop=True)
    .assign(**{
        'Text1': lambda df: df['Var1'].str.split('-').str[0],
        'Value1': lambda df: df['Var1'].str.split('-').str[1].astype(int),
        'Text2': lambda df: df['Var2'].str.split('-').str[0],
        'Value2': lambda df: df['Var2'].str.split('-').str[1].astype(int),
        'Total': lambda df: df['Value1'] + df['Value2']
    })
    .query('Text1 < Text2')
    .loc[:, ['Text1', 'Text2', 'Total']]
    .rename(columns={'Text1': 'Letter1', 'Text2': 'Letter2'})
    .sort_values(['Letter1', 'Letter2'])
)

print(result.equals(test))
