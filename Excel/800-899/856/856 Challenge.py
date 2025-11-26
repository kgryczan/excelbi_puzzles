import pandas as pd
import re

path = "Excel/800-899/856/856 Capitalize Consonants Around Vowels.xlsx"
input = pd.read_excel(path, usecols="A", nrows=10)
test = pd.read_excel(path, usecols="B", nrows=10)

pattern = r'(?<=[aeiou])([^aeiou])|([^aeiou])(?=[aeiou])'
input['out'] = input.iloc[:, 0].str.replace(pattern, lambda m: m.group(0).upper(), regex=True, flags=re.IGNORECASE)

print(input['out'].equals(test.iloc[:, 0])) # True
