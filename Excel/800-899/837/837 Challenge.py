import pandas as pd, numpy as np
import os

file_path = "800-899/837/837 Product and Sum of Digits are Same.xlsx"
df = pd.read_excel(file_path, usecols="A", nrows=10)
test = pd.read_excel(file_path, usecols="B", nrows=5)


digits = df.iloc[:,0].astype(str).str.replace(r'\D', '', regex=True)
sum_digits = digits.map(lambda x: sum(map(int, x)))
prod_digits = digits.map(lambda x: np.prod(list(map(int, x))) if x else 0)

result = digits[(sum_digits == prod_digits)].astype(int).reset_index(drop=True).to_frame('Answer Expected')

print(result.equals(test))  # True
