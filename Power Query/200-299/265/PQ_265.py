import pandas as pd

path = "PQ_Challenge_265.xlsx"
input = pd.read_excel(path, usecols="A:G", nrows=6)
test = pd.read_excel(path, usecols="A:C", skiprows=9, nrows=12).sort_values(by = ["Factory", 'Part']).reset_index(drop=True)

melted = input.melt(id_vars='Factory', value_vars=['Part1', 'Part2', 'Part3', 'Price1', 'Price2', 'Price3'],
                    var_name='Column', value_name='Value')
melted[['Type', 'Set']] = melted['Column'].str.extract(r'([a-zA-Z]+)(\d+)')
melted = melted.drop(columns=['Column', 'Set']).dropna().reset_index(drop=True)
melted['RowNumber'] = melted.groupby('Type').cumcount() + 1
pivoted = melted.pivot(index=['RowNumber', 'Factory'], columns='Type', values='Value').sort_values(by=["Factory", 'Part']).reset_index()
pivoted = pivoted.drop(columns=['RowNumber']).astype({'Price': 'int64'}).rename_axis(None, axis=1)
print(pivoted.equals(test)) # True