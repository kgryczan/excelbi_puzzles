import pandas as pd

path = "674  Consecutive Numbers.xlsx"
input = pd.read_excel(path, usecols="A", nrows=14)
test = pd.read_excel(path, usecols="B:E", nrows=4, names=["1", "2", "3", "4"]).fillna('')
test['3'] = test['3'].astype('float64')

input['Group'] = (input['Numbers'] != input['Numbers'].shift()).cumsum()
filtered_input = input.groupby('Group').filter(lambda x: len(x) > 1)
filtered_input['RowNumber'] = filtered_input.groupby('Group').cumcount() + 1
filtered_input = filtered_input.pivot(index='RowNumber', columns='Group', values='Numbers').fillna('').reset_index(drop=True)
filtered_input.columns = test.columns

print(filtered_input.equals(test)) # True