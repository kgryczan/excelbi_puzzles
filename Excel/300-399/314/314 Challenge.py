import pandas as pd

path = "300-399/313/313 Atbash Palindromes.xlsx"
input_df = pd.read_excel(path, usecols="A", nrows=9)
test = pd.read_excel(path, usecols="B", nrows=3)


def is_atbash_palindrome(word):
    vals = [ord(c) - ord("A") + 1 for c in word]
    return all(a + b == 27 for a, b in zip(vals, reversed(vals)))


result = (
    input_df[input_df["Text"].apply(is_atbash_palindrome)][["Text"]]
    .reset_index(drop=True)
)

print(result["Text"].equals(test["Answer Expected"]))
# True
