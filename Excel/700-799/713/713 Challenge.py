import pandas as pd

path = "700-799/713/713 Split and Extract.xlsx"

input = pd.read_excel(path, usecols="A:B", skiprows=1, nrows=4)
test = pd.read_excel(path, usecols="D:E", skiprows=1, nrows=10).rename(columns=lambda x: x.rstrip('.1'))

input = (input.assign(Group=lambda x: x.index + 1, 
                      Data=lambda x: x['Data'].str.split(', '))
             .explode('Data')
             .assign(Position=lambda x: x.groupby('Group').cumcount() + 1,
                     Value=lambda x: x['Position'] * x['Value']))

result = input[['Data', 'Value']].reset_index(drop=True)
print(result.equals(test))
