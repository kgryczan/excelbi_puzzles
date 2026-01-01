import pandas as pd

path = "Excel/800-899/882/882 Reverse Add Palindrome.xlsx"
input = pd.read_excel(path, usecols="A", nrows=51)
test = pd.read_excel(path, usecols="B", nrows=51)

def is_palindrome(x):
    s = str(x)
    return s == s[::-1]

def solve_pals(n):
    current = n
    for _ in range(1001):
        if is_palindrome(current):
            return current
        rev_num = int(str(current)[::-1])
        current += rev_num
    return current  

input['Answer Expected'] = input['Numbers'].apply(solve_pals)
print(input['Answer Expected'].equals(test['Answer Expected'])) # True
