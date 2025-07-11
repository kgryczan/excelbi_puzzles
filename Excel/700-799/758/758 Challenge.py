import pandas as pd
from functools import lru_cache

path = "700-799/758/758 First 5 Consecutive Happy Numbers.xlsx"
test = pd.read_excel(path, usecols="A", nrows=6).iloc[:, 0].tolist()

@lru_cache(maxsize=None)
def is_happy(n):
    while True:
        n = sum(int(digit) ** 2 for digit in str(n))
        if n == 1:
            return True
        if n == 4:
            return False

def find_consec_happy_seq(k):
    n = 1
    while True:
        if all(is_happy(x) for x in range(n, n + k)):
            return list(range(n, n + k))
        n += 1

result = find_consec_happy_seq(5)
print(result == test) # True