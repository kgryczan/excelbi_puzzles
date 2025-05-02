import pandas as pd
import re

path = "707 Split at Non Alphabetic Delimiters.xlsx"
input = pd.read_excel(path, usecols="A", nrows=10)
test = pd.read_excel(path, usecols="B", nrows=36)

result = input['Sentences'].str.split(r'[^a-zA-Z]+', expand=True).stack().reset_index(drop=True)

print(result.equals(test['Expected Answer'])) # True 

