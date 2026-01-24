import pandas as pd
import numpy as np

path = "Excel/800-899/898/898 Pivot.xlsx"
input = pd.read_excel(path, usecols="A:C", skiprows=1, nrows=21)
test = pd.read_excel(path, usecols="E:H", skiprows=1, nrows=10).rename(columns=lambda col: col.replace('.1', ''))

input['Zone'] = np.where(input['Type'] == 'Zone', input['Value'], np.nan)
input['Zone'] = input.groupby('LogID')['Zone'].transform(lambda x: x.ffill().bfill())
input['Part'] = np.where(input['Type'] == 'Part', input['Value'], np.nan)
input['Part'] = input.groupby(['LogID', 'Zone'])['Part'].transform(lambda x: x.ffill())
input['Quantity'] = np.where(input['Type'] == 'Qty', pd.to_numeric(input['Value'], errors='coerce'), np.nan)
input['Quantity'] = input.groupby(['LogID', 'Zone', 'Part'])['Quantity'].transform(lambda x: x.ffill().bfill())
input['Quantity'] = input['Quantity'].fillna(1).astype('int64')
result = input.drop(['Type', 'Value'], axis=1)
result = result[result['Part'].notna()]
result = result.drop_duplicates()
result['Quantity'] = result['Quantity'].fillna(1)
test = test.reset_index(drop=True)
result = result.reset_index(drop=True)

print(result.equals(test))
# Output: True