import pandas as pd
import math
from itertools import product

path = "Excel/800-899/891/891 Sum of Two Perfect Squares.xlsx"

input = pd.read_excel(path, usecols="A", nrows=15)
test = pd.read_excel(path, usecols="B", nrows=15)


def find_square_pairs(n):
    limit = math.isqrt(n)
    pairs = [
        f"{i}-{j}"
        for i, j in product(range(limit + 1), repeat=2)
        if i <= j and i**2 + j**2 == n
    ]
    return ", ".join(pairs) if pairs else "No"

input["Pairs"] = input["Number"].apply(find_square_pairs)

print(input["Pairs"]==test["Answer Expected"])
# 3rd result is incorrect.