import pandas as pd

path = "591 Sum of Numbers following Hashes.xlsx"
input = pd.read_excel(path, usecols="A", nrows=20)
test = pd.read_excel(path, usecols="B", nrows=20)

input['group'] = (input['Data'] == '#').cumsum()
input['Data'] = pd.to_numeric(input['Data'], errors='coerce')
input['Data'] = input['Data'].fillna(input.groupby('group')['Data'].transform('sum')).astype('int64')

print(input['Data'].equals(test['Answer Expected']))    # True