import pandas as pd
import re

path = "612 Names Having First and Last Names 1st Characters Same.xlsx"
input = pd.read_excel(path, usecols="A", nrows=20)
test = pd.read_excel(path, usecols="B", nrows=5)

extract_initials = lambda name: ''.join(re.findall(r'[A-Z]', name)[:1] + re.findall(r'[A-Z]', name)[-1:])
result = input.assign(initials=input['Names']\
                .apply(extract_initials))\
                .groupby('initials')\
                .filter(lambda x: len(x) > 1)\
                .sort_values(by='Names').reset_index()

print(result['Names'].equals(test['Answer Expected'])) # True