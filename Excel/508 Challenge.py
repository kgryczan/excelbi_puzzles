import math
import pandas as pd

path = "508 Number is Perfect Square and Sum of Squares of Digits is also a Perfect Square.xlsx"
test = pd.read_excel(path, usecols="A").values.flatten().tolist()

def is_perfect_square(n):
    return int(math.isqrt(n))**2 == n

perfect_squares = [i**2 for i in range(10, int(math.sqrt(10**10)) + 1)]
result = [x for x in perfect_squares if is_perfect_square(sum(int(digit)**2 for digit in str(x)))][:500]

print(result == test) # True