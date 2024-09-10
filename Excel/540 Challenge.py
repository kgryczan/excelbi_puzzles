import numpy as np
import pandas as pd
from itertools import product

path = "540 Right Angled Triangles.xlsx"
input = pd.read_excel(path, skiprows=1, usecols="A:B")
test = pd.read_excel(path, skiprows=1, usecols="C:D")

def process_triangle(area, hypotenuse):
    ab_divisors = [d for d in range(1, 2 * area + 1) if (2 * area) % d == 0]
    result = [(a, b) for a, b in product(ab_divisors, ab_divisors) if a * b == 2 * area and hypotenuse**2 == a**2 + b**2 and a < b]
    return pd.DataFrame(result, columns=['Perpendicular', 'Base']) if result else pd.DataFrame({'Perpendicular': ['NP'], 'Base': ['NP']})

output = pd.concat([process_triangle(row['Area'], row['Hypotenuse']) for _, row in input.iterrows()], ignore_index=True)
output.fillna('NP', inplace=True)

print(output.equals(test)) # True
