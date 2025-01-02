import pandas as pd
import numpy as np

path = "622 At least 3 different vowels.xlsx"
input = pd.read_excel(path, usecols="A:D", skiprows=1, nrows=15)
test = pd.read_excel(path, usecols="F:I", skiprows=1, nrows=5).rename(columns=lambda x: x.split('.')[0])

def count_unique_vowels(word):
    vowels = set('aeiou')
    return len(set(word.lower()) & vowels)

input_long = input.melt(var_name='list', value_name='word')
filtered = input_long[input_long['word'].astype(str).apply(lambda x: count_unique_vowels(x) >= 3)]
result = filtered.assign(rn=filtered.groupby('list').cumcount() + 1).pivot(index='rn', columns='list', values='word').reset_index(drop=True)

result.columns.name = None
result = result[['List1', 'List2', 'List3', 'List4']]

print(result.equals(test))