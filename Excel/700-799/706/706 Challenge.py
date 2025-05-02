import pandas as pd

path = "706 Running Total for Even & Odd.xlsx"

input = pd.read_excel(path, usecols="A", nrows=30)
test = pd.read_excel(path, usecols="B", nrows=30)

input['result'] = input.groupby(input['Numbers'] % 2)['Numbers'].cumsum()

print(input["result"].equals(test["Answer Expected"])) # True