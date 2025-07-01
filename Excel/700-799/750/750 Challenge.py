import pandas as pd
import numpy as np
import re

path = "700-799/750/750 Data Alignment.xlsx"
input = pd.read_excel(path, usecols="A", nrows=21).astype(str)
test = pd.read_excel(path, usecols="C:E", skiprows=1, nrows=4).rename(columns=lambda x: re.sub(r'\.1$', '', x))

input['group'] = input['Data'].str.contains("Emp ID").cumsum()
input['cn'] = np.where(input.groupby('group').cumcount() < input.groupby('group')['Data'].transform('count') // 2, 'labels', 'values')

labels_rows, values_rows = (input[input['cn'] == x] for x in ['labels', 'values'])

wide = pd.DataFrame({'labels': labels_rows['Data'].values, 'values': values_rows['Data'].values})
wide['group'] = wide['labels'].str.contains("Emp ID").cumsum()

pivoted = wide.pivot(index='group', columns='labels', values='values')
wide = pivoted.reset_index()
result = wide[['Emp ID', 'Name', 'Age']].copy()
result['Emp ID'] = result['Emp ID'].astype(int)
result['Age'] = result['Age'].astype(float)

print(result.equals(test)) # True