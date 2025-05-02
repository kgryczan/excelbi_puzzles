import pandas as pd
import numpy as np

path = "538 Emirps.xlsx"
test = pd.read_excel(path)

def generate_primes(limit):
    sieve = np.ones(limit + 1, dtype=bool) 
    sieve[0:2] = False 
    for i in range(2, int(limit**0.5) + 1):
        if sieve[i]:
            sieve[i*i:limit+1:i] = False  
    return sieve

max_n = 10000000
prime_mask = generate_primes(max_n)
df = pd.DataFrame({'n': range(10, max_n + 1)})
df['rev'] = df['n'].astype(str).str[::-1].astype(int)
df = df[(df['n'] != df['rev']) & prime_mask[df['n']] & prime_mask[df['rev']]]
df = df["n"].reset_index(drop=True)

print(df.equals(test["Expected Answer"])) # True
