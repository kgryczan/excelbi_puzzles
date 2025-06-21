import pandas as pd
import numpy as np

path = "200-299/297/PQ_Challenge_297.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=5)
test = pd.read_excel(path, usecols="D:F", nrows=15)

input_long = input.assign(**{
    'Animals & Count': input['Animals & Count'].str.split(', ')
}).explode('Animals & Count')

split = input_long['Animals & Count'].str.split('-', n=1, expand=True)
input_long['Animal'] = split[0]
input_long['Count'] = split[1].astype(float)

input_long['Count'] = input_long['Count'].fillna(1).astype(int)

input_long['Cage_num'] = input_long['Cage'].str.extract(r'(\d+)').astype(int)
input_long = input_long.sort_values(['Cage_num', 'Animal']).drop(columns='Cage_num')

input_long['Cage No'] = input_long.groupby('Cage')['Cage'].transform(
    lambda x: x if len(x) == 1 else x + '_' + (np.arange(1, len(x)+1)).astype(str)
)

result = input_long[['Cage No', 'Animal', 'Count']].reset_index(drop=True)

print(result.equals(test)) # True