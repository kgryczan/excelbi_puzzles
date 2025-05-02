import pandas as pd
from itertools import accumulate

path = "613 Sum of Digits Sequence.xlsx"
test = pd.read_excel(path, usecols="A", nrows=10001).squeeze()

def sum_of_digits(n):
    return sum(int(digit) for digit in str(n))

sequence = list(accumulate(range(1, 10001), lambda x, _: x + sum_of_digits(x), initial=1))
sequence = [1] + sequence[:-2]

print(all(sequence == test)) # True