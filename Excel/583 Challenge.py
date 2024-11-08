import pandas as pd

path = "583 Max for Cities & Birds Combination.xlsx"
input = pd.read_excel(path, usecols="A:F", skiprows=1, nrows=8)
test = pd.read_excel(path, usecols="H:I", skiprows=1, nrows=5)

input_long = input.melt(id_vars=input.columns[0], var_name="City", value_name="Count")
result = input_long[input_long['Count'] == input_long.groupby('City')['Count'].transform('max')].groupby('City').agg(
    Max=('Birds/City', ', '.join)
).reset_index().sort_values('City')

print(result.equals(test)) # True