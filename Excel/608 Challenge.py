import pandas as pd
import re
from country_list import countries_for_language

path = "608 Extract Zip and Country.xlsx"
input = pd.read_excel(path, usecols="A", skiprows=1, nrows=10)
test = pd.read_excel(path, usecols="B:C", skiprows=1, nrows=10)

def is_country(name):
    return name in dict(countries_for_language('en')).values()

def extract_zip_country(string):
    zip_code = re.search(r"(?<!\w)(?:[^a-z]|\s)(\d{5,6})(?=,| {2})|(^\d{5,6})", string)
    zip_code = int(zip_code.group()) if zip_code else None
    country = re.search(r'(\w+)? \w+$', string)
    country = country.group().strip() if country and is_country(country.group().strip()) else re.search(r'\w+$', string).group().strip() if re.search(r'\w+$', string) else None
    return zip_code, country

result = input['String'].apply(lambda x: pd.Series(extract_zip_country(x)))
result.columns = ['Zip', 'Country']

print(result.equals(test)) # True
