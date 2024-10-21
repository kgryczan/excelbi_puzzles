import pandas as pd
import numpy as np
from collections import Counter

path = "569 Diff of Common Counts.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=10).fillna("")
test = pd.read_excel(path, usecols="C", nrows=10)

def count_letters(s):
    s = s.lower()
    return Counter(s)

def process_strings(str1, str2):
    s1 = count_letters(str1)
    s2 = count_letters(str2)
    
    all_letters = set(s1.keys()).union(set(s2.keys()))
    diff_counts = {letter: abs(s1.get(letter, 0) - s2.get(letter, 0)) for letter in all_letters}
    diff_counts = {k: v for k, v in diff_counts.items() if v != 0}
    
    result = ''.join(f"{k}{v}" for k, v in sorted(diff_counts.items()))
    return result

input['Answer Expected'] = input.apply(lambda row: process_strings(row['String1'], row['String2']), axis=1)

print(np.array_equal(input['Answer Expected'].values, test['Answer Expected'].values)) # True