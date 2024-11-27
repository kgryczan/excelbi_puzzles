import pandas as pd

path = "596 Increment Sequences.xlsx"
input = pd.read_excel(path, usecols="A", nrows=18).fillna("")
test = pd.read_excel(path, usecols="B", nrows=18)

input['nr'] = (input['Alphabets'] != input['Alphabets'].shift()).cumsum()
input['nr2'] = input.groupby('Alphabets')['nr'].rank(method='dense').astype(int)
input['Answer Expected'] = input['Alphabets'].notna().astype(int) * input['nr2'].where(input['Alphabets'] != "", 0)

print(all(input['Answer Expected'] == test['Answer Expected'])) # True