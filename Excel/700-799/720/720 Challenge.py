import pandas as pd
import unicodedata
import re

path = "700-799/720/720 Transpose if minimum 2 different vowels.xlsx"
input = pd.read_excel(path, usecols="A:B", skiprows=1, nrows=15)
test = pd.read_excel(path, usecols="D:I", skiprows=1, nrows=3).rename(columns=lambda col: col.replace('.1', ''))

latin_ascii = lambda s: unicodedata.normalize('NFKD', str(s)).encode('ascii', 'ignore').decode()
unique_vowels = lambda s: set(re.findall(r'[aeiou]', s.lower()))

df = input.copy()
df['Rivers'] = df['Rivers'].map(latin_ascii)
df = df[df['Rivers'].map(lambda s: len(unique_vowels(s)) >= 2)]
df = df.sort_values(['Group', 'Rivers'])
df['rn'] = df.groupby('Group').cumcount() + 1
result = df.pivot(index='Group', columns='rn', values='Rivers').add_prefix('River').reset_index()
result.columns.name = None

print(result.equals(test))