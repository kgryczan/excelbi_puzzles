import math
import itertools
import pandas as pd

path = "484 Pythagorean Triplets for a Sum.xlsx"
input = pd.read_excel(path, usecols="A", skiprows=1)
test = pd.read_excel(path, usecols="B:D", skiprows=1)

def find_pythagorean_triplet(P):
    m_max = math.floor(math.sqrt(P / 2))
    
    possible_values = list(itertools.product(range(2, m_max + 1), range(1, m_max)))
    possible_values = [values for values in possible_values if values[0] > values[1] and values[0] % 2 != values[1] % 2 and math.gcd(values[0], values[1]) == 1]
    
    triplets = []
    for m, n in possible_values:
        k = P / (2 * m * (m + n))
        if k == math.floor(k):
            a = k * (m**2 - n**2)
            b = k * 2 * m * n
            c = k * (m**2 + n**2)
            triplets.append([a, b, c])
    
    triplet = [triplet for triplet in triplets if sum(triplet) == P]
    
    if len(triplet) > 0:
        result = triplet[0]
    else:
        result = [float('nan'), float('nan'), float('nan')]
    
    return pd.Series(result, index=['a', 'b', 'c'])

output = input['Sum'].apply(find_pythagorean_triplet)

# one case (for 132), I get different but correct answer