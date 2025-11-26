import pandas as pd

path = "Excel/800-899/855/855 Champion Non Continuous.xlsx"
input = pd.read_excel(path, usecols="A:B", skiprows=1, nrows=23)
test = pd.read_excel(path, usecols="D:E", skiprows=1, nrows=4)

input['n'] = input.groupby('Champion')['Champion'].transform('size')
input['Consecutive'] = (input['Champion'] == input['Champion'].shift()) & (input.index != 0)
valid = (~input.groupby('Champion')['Consecutive'].transform('max')) & (input['n'] >= 2)
result = (
    input[valid]
    .groupby('Champion', as_index=False)
    .agg({'Year': lambda x: ', '.join(map(str, x))})
    .sort_values('Champion')
    .rename(columns={'Champion': 'Country', 'Year': 'Years'})
)

print(result.equals(test)) # True
