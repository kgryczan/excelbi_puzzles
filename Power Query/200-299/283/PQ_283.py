import pandas as pd
path = "200-299/283/PQ_Challenge_283.xlsx"

input = pd.read_excel(path, usecols="A:C", nrows=10)
test = pd.read_excel(path, usecols="E:I", nrows=3).rename(columns=lambda x: x.split('.')[0])
test.iloc[:, 1:4] = test.iloc[:, 1:4].astype('float64')

result = input.pivot(index='ID', columns='Dept', values='Amount').reset_index()
result.columns = ['ID'] + [f"Dept {col}" for col in result.columns[1:]]
result = result[['ID'] + sorted(result.columns[1:])]

print(result.equals(test)) # True