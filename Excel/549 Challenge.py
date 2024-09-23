import pandas as pd
from num2words import num2words

path = "549 Oban Numbers.xlsx"
test = pd.read_excel(path, usecols="A")

input = pd.DataFrame(range(1, 1001), columns=["Number"])
output = input[~input["Number"].apply(num2words).str.contains("o")].reset_index(drop=True)

print(output["Number"].equals(test["Answer Expected"]))  # True