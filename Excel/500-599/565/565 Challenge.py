import pandas as pd
import math

path = "565 Even Number and Reversal Perfect Square.xlsx"
test = pd.read_excel(path, usecols="A", nrows=51)

def is_even(x):
    return x % 2 == 0

def is_perfect_square(x):
    sqrt_x = math.sqrt(x)
    return sqrt_x == int(sqrt_x)

def reverse_number(x):
    return int(str(x)[::-1])

def find_even_reverse_perfect_squares(n_required):
    results = []
    n = 10
    
    while len(results) < n_required:
        square = n ** 2
        reverse_square = reverse_number(square)
        if is_even(square) and is_even(reverse_square) and is_perfect_square(reverse_square):
            results.append({'original': square, 'reverse': reverse_square})
        n += 1
    return results

result = pd.DataFrame(find_even_reverse_perfect_squares(50))

print(result['original'].equals(test['Expected Answer']))
# True