import pandas as pd

path = "700-799/752/752 Sort on Maximum Digits.xlsx"

input = pd.read_excel(path, usecols="A", nrows=11)
test = pd.read_excel(path, usecols="B", nrows=11)

input['Sorted'] = input['Numbers'].astype(str).apply(lambda x: ''.join(sorted(x, reverse=True)))
result = input.sort_values(by='Sorted', ascending=False)['Numbers'].reset_index(drop=True)

print(result.equals(test['Answer Expected'])) # True
