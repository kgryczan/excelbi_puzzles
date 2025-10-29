import pandas as pd

path = "800-899/836/836 Index and Running Total.xlsx"

input = pd.read_excel(path, usecols="A", skiprows=1, nrows=20)
test = pd.read_excel(path, usecols="C:D", skiprows=1, nrows=20)

input['Group Index'] = (input['Data'].isna().cumsum() + 1).where(~input['Data'].isna())
input['Running Sum'] = input.groupby('Group Index')['Data'].cumsum()
result = input.drop(columns=['Data'])

print(result.equals(test)) 