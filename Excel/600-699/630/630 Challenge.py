import pandas as pd

path = "630 Immediate Last Caller.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=16)
test = pd.read_excel(path, usecols="D", nrows=16)

input['Answer Expected'] = input.sort_values(by='Time').groupby('Date')['Caller'].shift()
print(input['Answer Expected'].equals(test['Answer Expected'])) # True