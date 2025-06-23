import pandas as pd
import re

path = "700-799/744/744 Capitalize the Consonant After a Vowel.xlsx"
input = pd.read_excel(path, usecols="A", nrows=10)
test = pd.read_excel(path, usecols="B", nrows=10)
pattern = r'([aeiou][0-9]?)([b-df-hj-np-tv-z])'

def capitalize_consonant(s):
    return re.sub(pattern, lambda m: m.group(1) + m.group(2).upper(), s, flags=re.IGNORECASE)

input['Expected Answer'] = input.iloc[:,0].apply(capitalize_consonant)
input.drop(columns=input.columns[0], inplace=True)

print(input.equals(test)) # True