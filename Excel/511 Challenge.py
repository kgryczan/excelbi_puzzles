from spellchecker import SpellChecker
import re
import pandas as pd

path = "511 Pig Latin Decrypter.xlsx"
input = pd.read_excel(path, usecols="A")
test  = pd.read_excel(path, usecols="B")
    
spell = SpellChecker()

def rotate_word(word: str, n: int) -> str:
    return word[n:] + word[:n]

def decrypt_pig_latin(sentence: str) -> str:
    words = sentence.split()
    decrypted_words = []
    for word in words:
        match = re.match(r'(.+?)(ay)([^\w\s]*)$', word)
        if match:
            base_word, _, punctuation = match.groups()
        else:
            base_word, punctuation = word, ""
        valid_words = []
        for i in range(len(base_word)):
            rotated = rotate_word(base_word, i)
            if spell.known([rotated]):
                valid_words.append(rotated + punctuation)
        if valid_words:
            decrypted_words.append('/'.join(valid_words))
        else:
            decrypted_words.append(word)
    return ' '.join(decrypted_words)

input['Answer Expected'] = input['Encrypted Text'].apply(decrypt_pig_latin)
input.drop(columns='Encrypted Text', inplace=True)

print(input == test)  

#    Answer Expected
# 0             True
# 1             True
# 2             True
# 3             True
# 4             True
# 5             True
# 6             True
# 7            False     who/how was your weekend?
# 8             True