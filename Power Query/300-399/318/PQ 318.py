import pandas as pd
import re

path = "300-399/318/PQ_Challenge_318.xlsx"
input = pd.read_excel(path, sheet_name=1, usecols="A:F", nrows=7)
test = pd.read_excel(path, sheet_name=1, usecols="A:E", skiprows=10, nrows=7)

df = input.melt(id_vars=["Alphabet"], var_name="atr", value_name="value").dropna(subset=["value"])
df[['Row', 'Col']] = df['value'].str.extract(r'(R\d+)(C\d+)')
input = df.pivot(index='Row', columns='Col', values='Alphabet').reset_index().rename_axis(None, axis=1).rename(columns={'Row': 'Row / Col'})

print(input.equals(test)) # True
