import pandas as pd

path = "689 Consecutive Numbers Marking.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=29)
test = pd.read_excel(path, usecols="D", nrows=29)

input['rn'] = range(1, len(input) + 1)
input['group_id'] = (
    (input['ID'] != input['ID'].shift(1)) |
    ((input['Number'] - input['rn']) != (input['Number'] - input['rn']).shift(1))
).cumsum()
input['answer_expected'] = input.groupby('group_id')['group_id'].transform('size')
result = input[['answer_expected']]

print(result['answer_expected'].equals(test['Answer Expected']))
