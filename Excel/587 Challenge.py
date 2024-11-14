import pandas as pd

path = "587 Repeat Vowels Order of Occurrence.xlsx"
input = pd.read_excel(path, usecols="A", nrows=10)
test = pd.read_excel(path, usecols="B", nrows=10)

def repeat_vowels(word):
    vowels = "aeiou"
    vowel_count = 0
    return ''.join(char * (vowel_count := vowel_count + 1) if char in vowels else char for char in word)

result = input["Strings"].apply(repeat_vowels)

print(result.equals(test["Answer Expected"])) # True