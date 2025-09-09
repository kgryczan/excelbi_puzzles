import pandas as pd

path = "800-899/800/800 Split and Expand.xlsx"
input = pd.read_excel(path, usecols="A:B", skiprows=1, nrows=4)
test = pd.read_excel(path, usecols="D:E", skiprows=1, nrows=11).rename(columns=lambda c: c.replace('.1', ''))

input_expanded = input.assign(
    Band=input['Band'].str.split(', ')
).explode('Band')

input_expanded = input_expanded[input_expanded['Band'].str.contains('-')]
input_expanded['Numbers'] = input_expanded['Band'].str.split('-').apply(lambda x: range(int(x[0]), int(x[1]) + 1))
result = input_expanded.explode('Numbers').drop(columns='Band').reset_index(drop=True)
result['Numbers'] = result['Numbers'].astype(int)

print(result.equals(test)) # True
