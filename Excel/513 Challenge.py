import pandas as pd

path = "513 Sort by Unit Digit.xlsx"
input = pd.read_excel(path, usecols = "A")
test  = pd.read_excel(path, usecols = "B")

result = input.copy()
result['sort'] = result['Numbers'].apply(lambda x: x % 10)
result = result.sort_values(by = 'sort').drop(columns = 'sort').reset_index(drop = True)
print(result['Numbers'].equals(test['Answer Expected'])) # True