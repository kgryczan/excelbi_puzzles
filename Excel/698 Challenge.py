import pandas as pd

path = "698 Alignment of Data.xlsx"
input = pd.read_excel(path, usecols="A", skiprows=1, nrows=23)
test = pd.read_excel(path, usecols="C:J", skiprows=1, nrows=5)

input['rn'] = input.groupby('Alphabets').cumcount() + 1                                 
input['rn2'] = input['Alphabets'].apply(lambda x: ord(x) - ord('A') + 1)
result = input.pivot(index='rn2', columns='rn', values='Alphabets').reset_index(drop=True)
result = result.sort_index().reset_index(drop=True)

result.columns.name = None
print(result.equals(test)) # True