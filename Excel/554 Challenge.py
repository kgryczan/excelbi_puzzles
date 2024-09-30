import pandas as pd
import math

path = "554 Kaprekar Numbers.xlsx"
test = pd.read_excel(path, usecols="A", nrows=51)

def check_kaprekar_fast(n):
    nsqr = n ** 2
    digits = math.floor(math.log10(nsqr)) + 1
    for split_pos in range(1, digits):
        right_part = nsqr % (10 ** split_pos)
        left_part = nsqr // (10 ** split_pos)
        if right_part > 0 and left_part + right_part == n:
            return True
    return False

n_values = range(4, 1000001)
kaprekar_flags = [check_kaprekar_fast(n) for n in n_values]

df = pd.DataFrame({'n': n_values, 'is_kaprekar': kaprekar_flags})
df = df[df['is_kaprekar']].head(50).loc[:, ['n']].reset_index(drop=True)

print(df["n"].equals(test["Answer Expected"])) # True