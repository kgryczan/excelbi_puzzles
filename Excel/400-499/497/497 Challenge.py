import pandas as pd
import math
import numpy as np

path = "497 Sum for Increasing Range.xlsx"
input = pd.read_excel(path, usecols="A", nrows = 100)
test = pd.read_excel(path, usecols="C:D", nrows = 14)

def is_triangular(n):
    n = 8 * n + 1
    return math.floor(math.sqrt(n)) == math.sqrt(n)

input['row'] = np.arange(1, len(input) + 1)
input['triangular'] = input['row'].apply(is_triangular)
input['cumsum'] = input['triangular'].cumsum()
input['Cells'] = np.where(~input['triangular'], input['cumsum'] + 1, input['cumsum'])

result = input.groupby('Cells', as_index=False)['Numbers'].sum().rename(columns={'Numbers': 'Sum'})
result['Cells'] = result['Cells'].replace(14, 'Remaining')

print(result.equals(test))  # True