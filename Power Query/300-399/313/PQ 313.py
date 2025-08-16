import pandas as pd
import numpy as np

path = "300-399/313/PQ_Challenge_313.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=18)
test = pd.read_excel(path, usecols="D:E", nrows=4)

pivoted = input.assign(group=(input['Data1'] == "Customer").cumsum()) \
    .pivot(index='group', columns='Data1', values='Data2') \
    .reset_index(drop=True)
pivoted.iloc[:, 1:] = pivoted.iloc[:, 1:].apply(pd.to_numeric, errors='coerce')

pivoted['Total Amount'] = (
    pivoted['Quantity'] * (
        pivoted['Price']
        - pivoted.filter(like='Disc').sum(axis=1, skipna=True)
        - pivoted.filter(like='Tax').sum(axis=1, skipna=True)
    )
).astype('int64')

result = pivoted[['Customer', 'Total Amount']]
result.loc[len(result)] = ['Total Sale', result['Total Amount'].sum()]

print(test.equals(result)) # True