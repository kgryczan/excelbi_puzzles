import pandas as pd
import itertools
import math

path = "524 Fill in Digits to make Perfect Square.xlsx"
input = pd.read_excel(path, usecols="A")
test  = pd.read_excel(path, usecols="B")

def find_square(x):
    chars = list(x)
    mapped_values = [(range(10) if ch == 'X' else [int(ch)]) for ch in chars]
    combinations = itertools.product(*mapped_values)
    
    result = [
        int(''.join(map(str, combo)))
        for combo in combinations
        if math.isqrt(int(''.join(map(str, combo)))) ** 2 == int(''.join(map(str, combo)))
    ]
    # for empty result return "NP"
    # for one element in result return that element
    # for more than one element return concatenated elements
    return result[0] if len(result) == 1 else (', '.join(map(str, result)) if len(result) > 1 else "NP")

input['Perfect Square'] = input['Numbers'].apply(find_square)

print(input)
print(test)