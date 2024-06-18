import pandas as pd
import numpy as np

path = "480 Caesar's Cipher_Decrypter.xlsx"
input = pd.read_excel(path, usecols="A:B")
test = pd.read_excel(path, usecols="C")

def decrypt_caesar(encrypted_text, shift):
    def shift_char(char, shift_value):
        if char.isalpha():
            base = 97 if char.islower() else 65
            char_val = ord(char) - base
            shifted_val = (char_val - shift_value) % 26
            return chr(shifted_val + base)
        else:
            return char

    decrypt_char = np.vectorize(shift_char)
    decrypted_text = ''.join(decrypt_char(list(encrypted_text), np.arange(len(encrypted_text)) + shift))
    return decrypted_text

result = input.copy() 
result['Answer Expected'] = result.apply(lambda row: decrypt_caesar(row['Encrypted Text'], row['Shift']), axis=1)

print(result['Answer Expected'].equals(test['Answer Expected'])) # True