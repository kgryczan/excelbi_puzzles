import pandas as pd

test = pd.read_excel("464 Palindromic Evil Numbers.xlsx", usecols="A")

is_palindromic = lambda x: str(x) == str(x)[::-1]
is_evil = lambda x: bin(x).count("1") % 2 == 0

range = range(10, 1000000)
result = [x for x in range if is_palindromic(x) and is_evil(x)][:1000]

print(result == test["Answer Expected"].tolist()) # True
