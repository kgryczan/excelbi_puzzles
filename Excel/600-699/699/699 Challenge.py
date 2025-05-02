import pandas as pd

path = "699 Palindrome after one character removal.xlsx"
input = pd.read_excel(path, usecols="A", nrows=10, names=["Words"])
test = pd.read_excel(path, usecols="B", nrows=10, names=["Answer Expected"]).fillna("")

def is_palindrome(word):
    return word == word[::-1]

result = input["Words"].apply(
    lambda word: next((word[:i] + word[i+1:] for i in range(len(word)) if is_palindrome(word[:i] + word[i+1:])), "")
)
print(result)
