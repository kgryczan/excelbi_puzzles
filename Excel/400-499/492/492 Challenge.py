import pandas as pd

path = "492 Date Shift Cipher Decrypter.xlsx"

input = pd.read_excel(path, usecols="A:B", nrows = 7)
test = pd.read_excel(path, usecols="C", nrows = 7)

def decrypt_date_cipher(text, date):
    repeat_date = (str(date) * ((len(text) // len(str(date))) + 1))[:len(text)]
    text_nums = [ord(char.lower()) - ord('a') for char in text]
    key_nums = [int(char) for char in repeat_date]
    decrypted_nums = [(text_num - key_num + 26) % 26 + ord('a') for text_num, key_num in zip(text_nums, key_nums)]
    decrypted_text = ''.join(chr(num) for num in decrypted_nums)
    return decrypted_text

input["Answer Expected"] = input.apply(lambda x: decrypt_date_cipher(x[0], x[1]), axis=1)

print(input["Answer Expected"].equals(test["Answer Expected"])) # True