import pandas as pd
import re

path = "700-799/762/762 Alphabets Pivot.xlsx"

input = pd.read_excel(path, usecols="A", skiprows=1, nrows=4)
test = pd.read_excel(path, usecols="C:D", skiprows=1, nrows=7)

input['fragment'] = input['Data'].apply(lambda x: re.findall(r"[A-Za-z]+\d+", str(x) if pd.notnull(x) else ""))
input = input.explode('fragment')
input['letters'] = input['fragment'].apply(lambda x: re.search(r"[A-Za-z]+", x).group())
input['digits'] = input['fragment'].apply(lambda x: int(re.search(r"\d+", x).group()))
input['Value'] = input['digits'] / input['letters'].apply(len)
input['Alphabet'] = input['letters'].apply(list)
input = input.explode('Alphabet')

result = input.groupby('Alphabet')['Value'].sum().astype(int)
result = result.reset_index()

print(result.equals(test))