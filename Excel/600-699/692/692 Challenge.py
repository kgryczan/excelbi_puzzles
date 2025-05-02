import pandas as pd

path = "692 Team having won all matches.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=11)
test = pd.read_excel(path, usecols="E", nrows=1)

input['rn'] = range(1, len(input) + 1)
input['Teams'] = input['Team 1'] + "-" + input['Team 2']
input = input.drop(columns=['Team 1', 'Team 2'])
input = input.assign(Result=input['Result'].astype(str).str.split('-'),
                           Teams=input['Teams'].str.split('-')).explode(['Result', 'Teams'])
input['verdict'] = input.groupby('rn')['Result'].transform(
    lambda x: ['WIN' if val == max(x.astype(int)) else 'LOSE' for val in x.astype(int)]
)
summary = input.groupby(['verdict', 'Teams']).size().reset_index(name='n')
result = summary[(summary['n'] == 4) & (summary['verdict'] == 'WIN')][['Teams']].reset_index(drop=True)

print(test["Answer Expected"].equals(result["Teams"]))