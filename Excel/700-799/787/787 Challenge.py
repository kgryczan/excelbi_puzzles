import pandas as pd

path = "700-799/787/787 Right Answer Selection.xlsx"

input = pd.read_excel(path, usecols="A:C", skiprows=1, nrows=13)
test = pd.read_excel(path, usecols="E:H", skiprows=1, nrows=3).rename(columns=lambda col: col.replace('.1', ''))

r1 = input[input['No'].astype(str).str.match(r'^\d+$') | (input['Correct'] == 'Y')].drop(columns=['Correct'])
part1 = r1[r1['No'].astype(str).str.match(r'^\d+$')].reset_index(drop=True)
part2 = r1[~r1['No'].astype(str).str.match(r'^\d+$')].reset_index(drop=True)
result = pd.concat([part1, part2], axis=1)
result.columns = test.columns
result['No'] = result['No'].astype(int)

print(result.equals(test))

