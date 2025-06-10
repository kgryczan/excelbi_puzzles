import pandas as pd

path = "700-799/735/735 Transpose.xlsx"
input = pd.read_excel(path, usecols="A", skiprows=1, nrows=5)
test = pd.read_excel(path, usecols="C:D", skiprows=1, nrows=6)

input_long = input['String'].str.split(', ', expand=True).stack().str.split(' - ', expand=True)
result = (input_long.groupby(1)[0]
          .unique()
          .apply(', '.join)
          .reset_index()
          .sort_values(1)
          .reset_index(drop=True)
          .rename(columns={1: 'Alphabet', 0: 'Planets'}))

print(result.equals(test))
# Earth missing in the expected output.