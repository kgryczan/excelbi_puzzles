import pandas as pd
import re
import operator

path = "700-799/747/747 Mathematical Operations.xlsx"
input = pd.read_excel(path, usecols="A", nrows=10)
test = pd.read_excel(path, usecols="B", nrows=10)

replacements = {
    r"\bminus\b": "-",
    r"\bplus\b": "+",
    r"\bmultiplication\b": "*",
    r"\bdivision\b": "/",
    r"\bmodulo\b": "%"
}

exprs = input.iloc[:, 0]
for word, op in replacements.items():
    exprs = exprs.str.replace(word, op, regex=True)

input['Answer Expected'] = exprs.apply(lambda x: int(eval(x)) if pd.notnull(x) else float('nan'))
result = input[['Answer Expected']]

print(result.equals(test))
