import pandas as pd

path = "700-799/769/769 Sum in First and Last Cells of Groups.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=21)
test = pd.read_excel(path, usecols="C", nrows=21)

input['group'] = input['Name'].isna().cumsum().mask(input['Name'].isna())
input['sum'] = input.groupby('group', dropna=True)['Number'].transform('sum')

def is_first_or_last(s):
    mask = [False] * len(s)
    if len(s) > 0:
        mask[0] = True
        mask[-1] = True
    return mask

mask = input.groupby('group', dropna=True)['Name'].transform(lambda x: x.index.isin([x.index[0], x.index[-1]]))
input['sum'] = input['sum'].where(mask & (input['sum'] != 0))
result = input

print(result['sum'].equals(test['Answer Expected']))
