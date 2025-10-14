import pandas as pd

path = "800-899/825/825 Unpivot.xlsx"
input = pd.read_excel(path, sheet_name=0, usecols="A:D", skiprows=1, nrows=3)
test = pd.read_excel(path, sheet_name=0, usecols="F:H", skiprows=1, nrows=14).rename(columns=lambda x: x.replace('.1', ''))

result = input.melt(id_vars='ID', var_name='Type', value_name='Entity')
result = result.dropna()
result = result.assign(Entity=result['Entity'].str.split(', ')).explode('Entity')
result = result.sort_values(['ID', 'Type', 'Entity'])
result['Type'] += '-' + (result.groupby('Type').cumcount() + 1).astype(str)
result = result[['ID', 'Entity', 'Type']].reset_index(drop=True)

print(result.equals(test)) # True