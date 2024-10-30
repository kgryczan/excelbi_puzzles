import pandas as pd

path = "576 Sort only Consonants.xlsx"
input = pd.read_excel(path, usecols="A", nrows=10)
test = pd.read_excel(path, usecols="B", nrows=10)

def process_column(word):
    col = list(word)
    consonant_pos = [i for i, letter in enumerate(col) if letter.lower() in "bcdfghjklmnpqrstvwxyz"]
    sorted_consonants = sorted([col[i] for i in consonant_pos])
    for i, pos in enumerate(consonant_pos):
        col[pos] = sorted_consonants[i]
    return ''.join(col)

input['result'] = input.iloc[:, 0].apply(process_column)

print(input["result"].equals(test["Answer Expected"])) # True
