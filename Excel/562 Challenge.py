import pandas as pd

path = "562 One Child Palindromes.xlsx"
test = pd.read_excel(path, usecols="A").squeeze().tolist()

def has_one_child(n):
    nchar = len(str(n))
    substrings = {int(str(n)[i:j].lstrip('0')) for i in range(len(str(n))) for j in range(i + 1, len(str(n)) + 1) if str(n)[i:j].lstrip('0')}
    substrings = [i for i in substrings if i != 0 and i % nchar == 0]
    return len(substrings) == 1

def is_palindromic(n):
    n = str(n)
    return n == n[::-1] and len(n) > 1

def is_palindromic_and_has_one_child(n):
    return is_palindromic(n) and has_one_child(n)

def find_first_1000():
    result, n = [], 0
    while len(result) < 1000:
        n += 1
        if is_palindromic_and_has_one_child(n):
            result.append(n)
    return result

result = find_first_1000()
print(result == test)   # True
 