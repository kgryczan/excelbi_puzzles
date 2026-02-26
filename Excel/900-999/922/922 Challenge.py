import pandas as pd
import re

path = "Excel/900-999/922/922 Reduce to Single Letter.xlsx"
input = pd.read_excel(path, usecols="A", nrows=11)
test = pd.read_excel(path, usecols="B", nrows=11)

def reduce_to_single_letter(text):
    return re.sub(r'([A-Za-z])\1+', r'\1', text)
input['Data'] = input['Data'].apply(reduce_to_single_letter)

print(input['Data'] == test['Answer Expected'])
# Note: one test case is incorrect.