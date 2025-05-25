import pandas as pd

path = "200-299/290/PQ_Challenge_290.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=12)
test = pd.read_excel(path, usecols="D:H", nrows=3)

input['group'] = (input['Column1'] == 'Company').cumsum()
result = input.pivot(index='group', columns='Column1', values='Column2').reset_index(drop=True)
result['Tax'] = result['Tax'].fillna(0).astype(int)
result['Profit'] = result.apply(
    lambda r: r['Revenue'] - r['Cost'] - r['Tax'] if pd.isna(r['Profit']) else r['Profit'], axis=1
).astype(int)
result = result[['Company', 'Revenue', 'Cost', 'Tax', 'Profit']]
result.columns.name = None
for col in ['Revenue', 'Cost']:
    result[col] = result[col].astype(int)
print(result.equals(test)) # True


