import pandas as pd

path = "800-899/835/835 Max Salary.xlsx"

input = pd.read_excel(path, usecols="A:C", skiprows=1, nrows=11)
test = pd.read_excel(path, usecols="E:G", skiprows=1, nrows=4).rename(columns=lambda x: x.replace('.1', ''))

input['Dept'] = input['Dept'].ffill()
result = input[input.groupby('Dept')['Salary'].transform('max') == input['Salary']].reset_index(drop=True)
result['Dept'] = result['Dept'].where(~result['Dept'].duplicated())
result = result.rename(columns={'Salary': 'Max Salary'})

print(result.equals(test)) # True