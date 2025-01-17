import pandas as pd
import random
import string

path = "633 Encryption by Printable Characters.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=10)

def n_random_chars(n):
    random_chars = ''.join(random.choices(string.printable, k=n))
    return random_chars

def encode_word(word, key):
    key = (key * (len(word) // len(key) + 1))[:len(word)]
    key_num = [string.ascii_lowercase.index(k) + 1 for k in key]
    return ''.join([w + n_random_chars(num) for w, num in zip(word, key_num)])

input['Sample_answer'] = input.apply(lambda row: encode_word(row['Words'], row['key']), axis=1)

print(input)