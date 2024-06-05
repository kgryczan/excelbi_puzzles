import pandas as pd
import string

input = pd.read_excel("471 Keyword Cipher Decrypter.xlsx", usecols="A:B", nrows = 9)
test = pd.read_excel("471 Keyword Cipher Decrypter.xlsx", usecols="C:C", nrows = 9)

def prepare_keycode(keyword):
    keyword = "".join(dict.fromkeys(keyword))  # Remove duplicates while preserving order
    alphabet = string.ascii_lowercase
    keycode = list(keyword) + [char for char in alphabet if char not in keyword]
    return keycode

def decode(sentence, keyword):
    keycode = prepare_keycode(keyword)
    code = dict(zip(keycode, string.ascii_lowercase))
    words = sentence.split()
    decoded_words = ["".join(code[char] for char in word) for word in words]
    decoded_sentence = " ".join(decoded_words)
    return decoded_sentence

result = input.copy()
result["Answer Expected"] = result.apply(lambda row: decode(row["Encrypted Text"], row["Keyword"]), axis=1)

print(result["Answer Expected"].equals(test["Answer Expected"])) # True