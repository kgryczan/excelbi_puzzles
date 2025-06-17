import pandas as pd

path = "700-799/740/740 Count Blanks.xlsx"
input = pd.read_excel(path, sheet_name="Sheet2", usecols="A", skiprows=1, nrows=39)
test = pd.read_excel(path, sheet_name="Sheet2", usecols="B:C", skiprows=1, nrows=8)

result = input.ffill().groupby('Data').size().sub(1).reset_index(name='Blanks Count')

print(result['Blanks Count'].equals(test['Blanks Count']))

