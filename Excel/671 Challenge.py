import pandas as pd
import re

path = "671 Word Pairs Having All Vowels.xlsx"
input = pd.read_excel(path, usecols="A", skiprows=1, nrows=10)
test = pd.read_excel(path, usecols="B:C", skiprows=1, nrows=5)

def extract_vowels(word):
    return ''.join(sorted(set(re.findall(r'[aeiou]', word))))

input_words = input.iloc[:, 0].tolist()

result = [
    (w1, w2) for i, w1 in enumerate(input_words)
    for w2 in input_words[i + 1:]
    if extract_vowels(w1 + w2) == 'aeiou'
]

result = pd.DataFrame(result, columns=['Var1', 'Var2'])
print(result)
# the same pairs, but with different order.