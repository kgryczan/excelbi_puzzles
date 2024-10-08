import pandas as pd
import re

path = "560 Vowels between Consonants.xlsx"
input = pd.read_excel(path, usecols="A", nrows=10)
test = pd.read_excel(path, usecols="B", nrows=10).fillna({'Answer Expected': ''})

def extract_cvc_overlap(input_string):
    return ', '.join(re.findall(r'(?=([^aeiou][aeiou]+[^aeiou]))', input_string)).strip()

input['result'] = input['Words'].apply(extract_cvc_overlap)

print(input['result'].equals(test['Answer Expected'])) # True
