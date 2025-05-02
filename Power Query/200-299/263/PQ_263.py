import pandas as pd

path = "PQ_Challenge_263.xlsx"
input1 = pd.read_excel(path, sheet_name=0, usecols="A:B", nrows=131)
input2 = pd.read_excel(path, sheet_name=0, usecols="D:F", nrows=6)
test = pd.read_excel(path, sheet_name=0, usecols="D:E", skiprows=11, nrows=5)

input2_long = input2.melt(var_name="Attitude", value_name="Response").dropna()

result = input2_long.merge(input1, left_on="Response", right_on="Responses", how="left")
result = result.groupby(['Store', 'Attitude']).size().reset_index(name='count')
result['Rank'] = result.groupby('Attitude')['count'].rank(method='dense', ascending=False)
result = result[result['Attitude'] == 'Green'][['Store', 'Rank']].sort_values(by = "Rank").reset_index(drop=True)

print(result)