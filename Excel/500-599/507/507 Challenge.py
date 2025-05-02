import pandas as pd
import re
from inflect import engine
from calendar import month_name

# Read the Excel file
path = "507 Lexically Sorted MDY Dates.xlsx"
input = pd.read_excel(path, usecols="A", dtype=str)
test = pd.read_excel(path, usecols="B", nrows = 3, dtype=str)

def number_to_words(num):
    p = engine()
    return p.number_to_words(num)

input['lit_month'] = input['Dates'].str[:2].astype(int).apply(lambda x: month_name[x]).str.lower()
input['lit_day'] = input['Dates'].str[2:4].astype(int).apply(lambda x: number_to_words(x))
input['lit_year'] = input['Dates'].str[4:].astype(int).apply(lambda x: number_to_words(x))

input['lit_date'] = input[['lit_month', 'lit_day', 'lit_year']].values.tolist()
input['lit_date_sorted'] = input['lit_date'].apply(sorted)
input = input[input['lit_date'] == input['lit_date_sorted']]
result = input[['Dates']].rename(columns={'Dates': 'Expected Answer'}).reset_index(drop=True)

print(result.equals(test)) # True