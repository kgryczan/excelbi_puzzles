import pandas as pd

path = "800-899/804/804 Sort Cities Names.xlsx"
input = pd.read_excel(path, usecols="A:B", skiprows=1, nrows=20)
test = pd.read_excel(path, usecols="D:E", skiprows=1, nrows=20).rename(columns=lambda c: c.replace('.1', ''))

result = (
    input
    .sort_values(['City', 'Names'])
    .assign(rn=lambda x: x.groupby('City').cumcount()+1)
    .sort_values(['rn', 'City'])
    .drop(columns='rn')
    .reset_index(drop=True)
)

print(result.equals(test)) # True