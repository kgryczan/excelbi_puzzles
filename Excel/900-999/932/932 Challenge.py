import pandas as pd
import numpy as np

path = "900-999/932/932 Largest Palindrome.xlsx"
input = pd.read_excel(path, usecols="A", nrows=9, dtype=str)
test = pd.read_excel(path, usecols="B", nrows=9, dtype=str)

def longest_palindrome(s):
    n = len(s)
    subs = [s[i:j] for i in range(n) for j in range(i + 2, n + 1)]
    pals = [sub for sub in subs if sub == sub[::-1]]
    if not pals:
        return np.nan
    max_len = max(len(p) for p in pals)
    return ", ".join(p for p in pals if len(p) == max_len)

result = input.assign(palindrome=input["Data"].map(longest_palindrome))
print(result["palindrome"].equals(test["Answer Expected"]))
# True
