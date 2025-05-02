import pandas as pd
from collections import Counter

path = "589 Longest Words in English.xlsx"
input = pd.read_excel(path, usecols="A", skiprows=1, nrows=6)
test = pd.read_excel(path, usecols="B:C", skiprows=1, nrows=6)

input['chars'] = input['Words'].apply(list)

input['Missing Alphabets'] = input['chars'].apply(lambda x: ", ".join([c for c in 'abcdefghijklmnopqrstuvwxyz' if c not in x]))
input['Highest Frequency'] = input['Words'].apply(lambda word: ", ".join(sorted([letter for letter, freq in Counter(word).items() if freq == max(Counter(word).values())])))
result = input.drop(columns=['chars', 'Words'])

print(result.equals(test)) # True