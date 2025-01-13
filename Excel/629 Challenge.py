import pandas as pd
import re

path = "629 Invert Sign.xlsx"
input = pd.read_excel(path, usecols="A", skiprows=0, nrows=10)
test = pd.read_excel(path, usecols="B", skiprows=0, nrows=10)

def switch_sign(match):
    signs = {"+": "-", "-": "+"}
    return signs[match.group(1)]
result = input['Words'].apply(lambda x: re.sub(r"([+-])(?=\d)", switch_sign, x))
print(result.equals(test['Answer Expected'])) # True