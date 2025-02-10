import pandas as pd

path = "649 Conditional Running Total.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=20)
test = pd.read_excel(path, usecols="D:D", nrows=20)

input['or_ind'] = input.index + 1
input = input.sort_values(by=['Group', 'or_ind'])
input['Value'] = input.apply(lambda row: 0 if row['Reset'] == 'Y' else row['Value'], axis=1)
input['inner_group'] = input['Reset'].eq('Y').cumsum()
input['Answer Expected'] = input.groupby(['Group', 'inner_group'])['Value'].cumsum()
input = input.sort_values(by='or_ind').reset_index(drop=True)

print(input['Answer Expected'].equals(test['Answer Expected'])) # True