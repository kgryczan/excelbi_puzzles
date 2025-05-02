import pandas as pd

path = "654 Percentage Within a Subgroup.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=12)
test = pd.read_excel(path, usecols="D", nrows=12)

input['Answer Expected'] = input.groupby('Group')['Revenue'].transform(lambda x: x / x.sum())

result = input['Answer Expected'].equals(test['Answer Expected'])
print(result) # True