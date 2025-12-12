import pandas as pd
import string

path = "Excel/800-899/868/868 Mirrored Caesar Pi Cipher.xlsx"
input_df = pd.read_excel(path, sheet_name=0, usecols="A", nrows=10)
test_df = pd.read_excel(path, sheet_name=0, usecols="B", nrows=10)

def reverse_words(text):
    return " ".join(text.split()[::-1])

def reverse_characters(text):
    return " ".join([word[::-1] for word in text.split()])

def atbash_cipher(text):
    lower = string.ascii_lowercase
    atbash = lower[::-1]
    trans = str.maketrans(lower, atbash)
    return "".join([c.translate(trans) if c in lower else c for c in text])

def pi_code(text):
    pi_digits = [3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5, 8, 9, 7, 9, 3, 2, 3, 8, 4]
    lower = string.ascii_lowercase
    text_chars = list(text)
    pi_idx = 0
    shifted_chars = []
    for char in text_chars:
        if char == " ":
            shifted_chars.append(" ")
        elif char in lower:
            shift = pi_digits[pi_idx]
            orig_pos = lower.index(char)
            new_pos = (orig_pos + shift) % 26
            shifted_chars.append(lower[new_pos])
            pi_idx = (pi_idx + 1) % len(pi_digits)
        else:
            shifted_chars.append(char)
    return "".join(shifted_chars)

def encode(text):
    return (
        pd.Series(text)
        .map(reverse_characters)
        .map(reverse_words)
        .map(atbash_cipher)
        .map(pi_code)
        .iloc[0]
    )

result = (
    input_df
    .assign(**{"Answer Expected": lambda df: df["Plain Text"].map(encode)})
)
print(result)
print(test_df)
