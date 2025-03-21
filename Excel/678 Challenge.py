import math
import pandas as pd
from pandas import read_excel

path = "678 Perfect Square Even if Reversed.xlsx"
test = read_excel(path,  usecols="A:B", skiprows=1, nrows=39)

def is_square(n):
    root = int(math.isqrt(n))
    return root * root == n

def reverse_digits(n):
    return int(str(n)[::-1])

squares = [i * i for i in range(1, 40000)]
valid = [sq for sq in squares 
         if is_square(reverse_digits(sq)) and (sq % 2 != reverse_digits(sq) % 2)]

result = valid[:50]

max_len = max(len([num for num in result if num % 2 == 0]), len([num for num in result if num % 2 != 0]))
df = pd.DataFrame({
    'Even': [num for num in result if num % 2 == 0] + [None] * (max_len - len([num for num in result if num % 2 == 0])),
    'Odd': [num for num in result if num % 2 != 0] + [None] * (max_len - len([num for num in result if num % 2 != 0]))
})

print(df.equals(test))