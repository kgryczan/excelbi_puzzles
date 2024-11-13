import pandas as pd

path = "586 Lookup.xlsx"
input = pd.read_excel(path, usecols="A:C", skiprows=1, nrows=16)
test = pd.read_excel(path, usecols="E:J", skiprows=1, nrows=8).rename(columns=lambda x: x.split('.')[0])

input['Animals'] = input['Animals'].ffill()
input['Count'] = input['Count'].apply(lambda x: 'Y' if x > 20 else 'N')
result = input.pivot(index='Animals', columns='Park', values='Count').fillna('NF')
result = result.reset_index()
result.columns.name = None

print(result.equals(test)) # True   