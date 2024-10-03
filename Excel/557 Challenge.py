import pandas as pd
import re

path = "557 Regex Challenges 2.xlsx"

input = pd.read_excel(path, usecols="A", nrows=6)
test = pd.read_excel(path, usecols="C", nrows=6)
test['Answer Expected'] = pd.to_numeric(test['Answer Expected'])

def extract_last_number(s):
    match = re.search(r'\d+(?!.*\d)', s)
    return int(match.group()) if match else None

def contains_all_vowels(s):
    return all(vowel in s for vowel in 'aeiou')

def is_strong_password(s):
    return bool(re.match(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[^A-Za-z0-9])(?=\S+$).{8,}$', s))

q1 = input.iloc[[0]].copy()
q1['Answer'] = q1['String'].apply(extract_last_number)

q2 = input.iloc[[1, 2]].copy()
q2['Answer'] = q2['String'].apply(lambda x: int(contains_all_vowels(x)))

q3 = input.iloc[[3, 4]].copy()
q3['Answer'] = q3['String'].apply(lambda x: int(is_strong_password(x)))

answer = pd.concat([q1, q2, q3], ignore_index=True)

print(answer["Answer"].equals(test["Answer Expected"])) # True