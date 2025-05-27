import pandas as pd

path = "700-799/725/725 Animal Count.xlsx"

input = pd.read_excel(path, sheet_name=0, usecols="A:D", skiprows=1, nrows=13)
test = pd.read_excel(path, sheet_name=0, usecols="F:J", skiprows=1, nrows=4)

long = input.melt(var_name="Company", value_name="Animal")
result = (long.groupby(['Company', 'Animal']).size()
          .unstack(fill_value=0)
          .reset_index())
result = result[['Company'] + sorted(result.columns.drop('Company'))]

print(result.equals(test)) # True