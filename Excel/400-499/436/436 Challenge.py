import pandas as pd
from itertools import permutations
from sympy import isprime

test = pd.read_excel("436 Pandigital Primes.xlsx", usecols="A", nrows=101)

def generate_pandigital(n):
    digits = list(range(1, n+1))
    digits = list(permutations(digits, n))
    digits = [int(''.join(map(str, x))) for x in digits]
    return digits

df = pd.DataFrame(columns=["numbers"])

for i in range(1, 8):
    pandigitals = generate_pandigital(i)
    df = df._append(pd.DataFrame({"numbers": pandigitals}))

df["is_prime"] = df["numbers"].apply(isprime)
df["numbers"] = df["numbers"].astype("int64")
result = df[df["is_prime"]].head(100).drop(columns="is_prime").reset_index(drop=True)
result.rename(columns={"numbers": "Answer Expected"}, inplace=True)

print(result.equals(test)) # True