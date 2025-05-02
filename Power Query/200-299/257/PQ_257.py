import pandas as pd

path = "PQ_Challenge_257.xlsx"
input = pd.read_excel(path,usecols="A:B", nrows=18, dtype = "str")
test = pd.read_excel(path, usecols="D:I", nrows=8, dtype = "str")

input['Counter'] = input.isnull().all(axis=1).cumsum() + 1
input.dropna(subset=['Birds'], inplace=True)
input['RowNumber'] = input.groupby('Counter').cumcount() + 2
input_pivot = input.pivot(index='Counter', columns='RowNumber', values=['Birds', 'Quantity'])
input_pivot.columns = [f'{col[0]}_{col[1]}' for col in input_pivot.columns]
input_pivot.reset_index(inplace=True)

df1 = input_pivot.filter(regex='^Counter|^Birds')
df2 = input_pivot.filter(regex='^Counter|^Quantity')
df1.columns = df2.columns = test.columns

result = pd.concat([df1, df2]).sort_index(kind='merge').reset_index(drop=True)
result['Column1'] = result.groupby('Column1').cumcount().map(lambda x: 'Birds' if x % 2 == 0 else 'Quantity')

print(result.equals(test))
