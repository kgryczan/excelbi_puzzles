import pandas as pd

path = "614 Consecutive Numbers Count.xlsx"

input = pd.read_excel(path, usecols="A", nrows=20)
test = pd.read_excel(path, usecols="B", nrows=20).fillna("")

def consecutive_id(series):
    return (series != series.shift()).cumsum()

input['group'] = consecutive_id(input.iloc[:, 0])
input['Answer Expected'] = input.groupby('group').transform(lambda x: x.size if x.size >= 2 else "")
result = input[['Answer Expected']]

print(result.equals(test)) #True