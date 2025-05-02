import pandas as pd
import re

path = "599 VLOOKUP.xlsx"
input = pd.read_excel(path, usecols="A:B", skiprows=1, nrows=10)
input2 = pd.read_excel(path, usecols="D", skiprows=1, nrows=6)
test = pd.read_excel(path, usecols="D:E", skiprows=1, nrows=5).sort_values(by="Words").reset_index(drop=True)

input['Column1'] = input['Column1'].str.lower()
input2[['w1', 'w2']] = input2['Words'].str.split(', ', expand=True)

cross_joined = input.assign(key=1).merge(input2.assign(key=1), on='key').drop('key', axis=1)

def check_word_presence(row):
    return bool(re.search(r'\b' + re.escape(str(row['w1'])) + r'\b', row['Column1'])) and \
           (pd.isna(row['w2']) or bool(re.search(r'\b' + re.escape(str(row['w2'])) + r'\b', row['Column1'])))

filtered = cross_joined[cross_joined.apply(check_word_presence, axis=1)]

result = filtered.groupby('Words')['Column2'].apply(', '.join).reset_index().sort_values(by='Words')
result.columns = ['Words', 'Result']

print(result.equals(test))  # True
