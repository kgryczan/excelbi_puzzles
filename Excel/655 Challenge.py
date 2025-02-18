import pandas as pd

path = "655 Increasing or Decreasing or None Sequences.xlsx"
input = pd.read_excel(path, usecols="A", nrows=8)
test = pd.read_excel(path, usecols="B", nrows=8)

input['rn'] = input.index + 1
input = input.assign(Sequences=input['Sequences'].str.split(',')).explode('Sequences').astype({'Sequences': int})
input['diff'] = input.groupby('rn')['Sequences'].diff()

result = input.dropna().groupby('rn').apply(
    lambda x: pd.Series({'Answer Expected': 'I' if all(x['diff'] > 0) else 'D' if all(x['diff'] < 0) else 'N'})
).reset_index()

result = result.drop(columns='rn')

print(result.equals(test))
