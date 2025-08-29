import pandas as pd
import random
import string

path = "700-799/793/793 Alphabet Shuffle.xlsx"
input = pd.read_excel(path , usecols="A:B", nrows=8)

def gen(s, l):
    chars = [string.ascii_uppercase[(string.ascii_uppercase.index(s) + i) % 26] for i in range(l)]
    for _ in range(10001):
        p = [x for _, x in sorted((random.random(), c) for c in chars)]
        if not any((ord(p[i-1]) - ord(p[i])) % 26 == 1 for i in range(1, l)):
            return ", ".join(p)

input['Shuffled'] = input.apply(lambda r: gen(r.Alphabet, r.Length), axis=1)

print(input)