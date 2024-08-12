import pandas as pd

path = "519 Sum of Digits of Number, Square and Cube are Same.xlsx"
test = pd.read_excel(path, usecols= "A")

def digit_sum(x):
    return sum([int(d) for d in str(x)])

x = 9
results = []

while len(results) < 25:
    n = digit_sum(x)
    s = digit_sum(x**2)
    c = digit_sum(x**3)
    
    if n == s and n == c:
        results.append({'x': x, 'n': n, 's': s, 'c': c})
    
    x += 1

results = pd.DataFrame(results)['x']

print(results.equals(test['Answer Expected'])) # True