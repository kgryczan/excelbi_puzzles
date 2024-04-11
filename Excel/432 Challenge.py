import pandas as pd
import re

input = pd.read_excel("432 Bifid Cipher_Part 1.xlsx", usecols="A", nrows=10)
test = pd.read_excel("432 Bifid Cipher_Part 1.xlsx", usecols="B", nrows=10)

def create_coding_square():
    alphabet = 'abcdefghiklmnopqrstuvwxyz'
    return {letter: ((index // 5) + 1, (index % 5) + 1) for index, letter in enumerate(alphabet)}

def bifid_encode(text):
    coding_square = create_coding_square()
    text = text.replace('j', 'i')
    text = ''.join(filter(str.isalpha, text))
    coords = [coding_square[letter] for letter in text if letter in coding_square]
    coords = list(zip(*coords))
    coords = coords[0] + coords[1]
    coords = [coords[i:i + 2] for i in range(0, len(coords), 2)]
    text = ''.join([list(coding_square.keys())[list(coding_square.values()).index((x[0], x[1]))] for x in coords])
    return text

input['Answer Expected'] = input['Plain Text'].apply(bifid_encode)
print(input['Answer Expected'].equals(test['Answer Expected'])) # True
