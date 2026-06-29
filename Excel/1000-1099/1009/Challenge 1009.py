import pandas as pd
import inflect

path = "1000-1099/1009/1009 Plurals.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=10, skiprows=0)
test = pd.read_excel(path, usecols="C", nrows=10, skiprows=0)

p = inflect.engine()
result = input.apply(
    lambda row: f"{p.number_to_words(row['Count'])} {p.plural(row['Word'], row['Count'])}",
    axis=1,
)

print(result.equals(test["Answer Expected"]))
# Fairies are wrong.
