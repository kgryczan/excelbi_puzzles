import pandas as pd

path = "300-399/320/PQ_Challenge_320.xlsx"

input = pd.read_excel(path, usecols="A:C", nrows=13)
test = pd.read_excel(path, usecols="E:I", nrows=4).rename(columns=lambda c: c.replace('.1', ''))

input['Customer'] = input['Customer'].ffill()
input = input[input['Customer'] != 'Total']

result = input.pivot(index='Customer', columns='Quarter', values='Amount')
result.columns = [f"{col} Amount" for col in result.columns]
result = result.reset_index()

print(result.equals(test)) # True