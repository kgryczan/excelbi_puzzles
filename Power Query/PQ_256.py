import pandas as pd
import numpy as np

path = "PQ_Problem_256.xlsx"
input = pd.read_excel(path,  usecols="A:I", nrows=4)
test = pd.read_excel(path,  usecols="A:C", skiprows=7, nrows=10)

for i in range(1, 8):
    input[f'T{i+1}'] = input[f'T{i}'] + pd.to_timedelta(input[f'Dur{i}'], unit='m') if i > 1 else input['Start Date Time'] + pd.to_timedelta(input[f'Dur{i}'], unit='m')

input.drop(columns=[col for col in input.columns if col.startswith('Dur')], inplace=True)
input.rename(columns={'Start Date Time': 'T1'}, inplace=True)

result = input.melt(id_vars=['State'], var_name='ID', value_name='Time').dropna()
result['order'] = result['ID'].str.extract(r'(\d)').astype(int).add(1).floordiv(2)
result['ID'] = np.where(result['ID'].str.extract(r'(\d)').astype(int).mod(2).eq(0), 'To', 'From')

result = result.pivot(index=['State', 'order'], columns='ID', values='Time').reset_index().rename_axis(None, axis=1)[['State', 'From', 'To']]

print(test.equals(result)) # True