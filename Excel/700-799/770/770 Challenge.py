import pandas as pd
import itertools
from math import prod

path = "700-799/770/770 Divisible by both Sum and Product of Digits.xlsx"
test = pd.read_excel(path, usecols="A", nrows=1000).iloc[:, 0].tolist()

def valid_numbers_fast(d):
    return [
        int(''.join(map(str, digits)))
        for digits in itertools.product(range(1, 10), repeat=d)
        if (s := sum(digits)) != 0
        and (p := prod(digits)) != 0
        and (n := int(''.join(map(str, digits)))) % s == 0
        and n % p == 0
    ]

result = pd.DataFrame({
    'digits': range(2, 9),
    'numbers': [valid_numbers_fast(d) for d in range(2, 9)]
})
result = result.explode('numbers').reset_index(drop=True).head(1000)

print(result['numbers'].tolist() == test) # True