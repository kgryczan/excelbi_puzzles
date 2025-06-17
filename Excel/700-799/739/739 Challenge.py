import pandas as pd

path = "700-799/739/739 Count Vowels in All Substrings.xlsx"
input = pd.read_excel(path, usecols="A", nrows=9)

def count_vowels_substrings(s):
    return sum((i+1)*(len(s)-i) for i, c in enumerate(s) if c.lower() in 'aeiou')

print([count_vowels_substrings(x) for x in input.iloc[:, 0]])