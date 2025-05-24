import pandas as pd
from itertools import permutations
from sympy import isprime

test = pd.read_excel("700-799/721/721 Prime_number_5digit.xlsx", usecols="A", nrows=62)
perms = (int(''.join(map(str, p))) for p in permutations(range(1,10), 5))

def check(n):
    return all(isprime(n % 10**i) for i in range(1, 6))

res = pd.DataFrame({'number': [n for n in perms if check(n)]})
print(res['number'].equals(test['Result']))
