import pandas as pd

path = "PQ_Challenge_271.xlsx"
input = pd.read_excel(path,  usecols="A:C", nrows=19)
test = pd.read_excel(path, usecols="E:H", nrows=11).rename(columns=lambda col: col.split('.')[0])

input['Rank'] = (
    input.groupby(
        (input['Group'] != input['Group'].shift()).cumsum()
    )['Revenue']
    .rank(method='dense', ascending=False)
    .astype('int64')    
)

result = (
    input[input['Rank'] <= (input['Group'] != input['Group'].shift()).cumsum()]
    .sort_values(['Group', 'Rank', 'Company'])
    [['Group', 'Company', 'Revenue', 'Rank']]
    .reset_index(drop=True)
)

print(test.equals(result)) # True