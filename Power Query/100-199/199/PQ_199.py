import pandas as pd
import re

path = "PQ_Challenge_199.xlsx"
input = pd.read_excel(path, usecols="A", nrows = 4)
test = pd.read_excel(path, usecols="C:D", nrows = 8)

pattern_no = r"\d{3}"
pattern_date = r"\d{1,2}/+\d{1,2}/+\d{2}"

result = input.copy()
result['Part No.'] = result['String'].str.findall(pattern_no)
result['Date'] = result['String'].str.findall(pattern_date)
result = result.explode('Part No.').explode('Date')
result['Date'] = result['Date'].str.replace("//", "/")
result = result.drop(columns=['String'])
result['Part No.'] = pd.to_numeric(result['Part No.'])
result['Date'] = pd.to_datetime(result['Date'], format="%m/%d/%y")
result = result.sort_values(['Part No.', 'Date']).reset_index(drop=True)

print(result.equals(test)) # True