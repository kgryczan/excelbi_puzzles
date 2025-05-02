import pandas as pd

def double_accumulative_cipher(word):
    letters = 'abcdefghijklmnopqrstuvwxyz'
    result = ''
    accumulative_sum = 0
    for char in word:
        index = letters.index(char.lower())
        accumulative_sum = (accumulative_sum + index) % 26
        result += letters[accumulative_sum]
    return result

test = pd.read_excel("427 Double Accumulative Cipher.xlsx", usecols="B", nrows=9)

input = pd.read_excel("427 Double Accumulative Cipher.xlsx", usecols="A", nrows= 9)
input['Answer Expected'] = input['Plain Text'].apply(double_accumulative_cipher).apply(double_accumulative_cipher)
input = input.drop(columns=['Plain Text'])

print(input.equals(test))   # True