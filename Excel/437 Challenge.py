import pandas as pd
import re
import re

input = pd.read_excel("437 Bifid Cipher_Part 2.xlsx", usecols="A:B", nrows=10)
test = pd.read_excel("437 Bifid Cipher_Part 2.xlsx", usecols="C", nrows=10)

def create_coding_square(keyword):
    keyword = keyword.replace('j', 'i')
    keyword = re.sub(r'[^a-z]', '', keyword.lower())
    keyword = ''.join(sorted(set(keyword), key=keyword.index))
    alphabet = 'abcdefghiklmnopqrstuvwxyz'
    for letter in keyword:
        alphabet = alphabet.replace(letter, '')
    keyword += alphabet
    coding_square = {}
    for i in range(5):
        for j in range(5):
            coding_square[keyword[i*5 + j]] = (i, j)
    coding_square = pd.DataFrame(coding_square).T.reset_index()
    return coding_square

def bifid_encode(text, keyword):
    coding_square = create_coding_square(keyword)
    text = text.replace('j', 'i')
    text = ''.join(filter(str.isalpha, text))
    coords = []
    for letter in text:
        letter_coords = coding_square[coding_square['index'] == letter].values[0][1:]
        letter_coords = [coord + 1 for coord in letter_coords]
        coords.append(letter_coords)
    coords = [item for sublist in coords for item in sublist]
    coords = [coords[i:i + 2] for i in range(0, len(coords), 2)]
    coords = list(zip(*coords))
    coords = coords[0] + coords[1]
    coords = [coords[i:i + 2] for i in range(0, len(coords), 2)]
    coords = [(coord[0] - 1, coord[1] - 1) for coord in coords]
    encoded_text = ''
    for coord in coords:
        encoded_text += coding_square[(coding_square[0] == coord[0]) & (coding_square[1] == coord[1])]['index'].values[0]
    return encoded_text

input['Answer Expected'] = input.apply(lambda row: bifid_encode(row['Plain Text'], row['Keywords']), axis=1)
print(input['Answer Expected'].equals(test['Answer Expected']))