import pandas as pd

path = "598 Palindromic Step Harshad Numbers.xlsx"
test = pd.read_excel(path, usecols="A", nrows=10).squeeze().tolist()

def is_palindromic(num):
    s = str(num)
    return s == s[::-1]

def is_step(num):
    digits = list(map(int, str(num)))
    return all(abs(digits[i] - digits[i+1]) == 1 for i in range(len(digits) - 1))

def is_harshad(num):
    digit_sum = sum(map(int, str(num)))
    return num % digit_sum == 0

range_limit = 10000000
range_start = 10

palindromic = [n for n in range(range_start, range_limit + 1) if is_palindromic(n)]
step_palindromic = [n for n in palindromic if is_step(n)]
result = [n for n in step_palindromic if is_harshad(n)]

print(result == test) # True
