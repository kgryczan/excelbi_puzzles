import pandas as pd
import numpy as np
from itertools import combinations

path = "537 Minimum Product for Triplet.xlsx"
input = pd.read_excel(path, usecols="A:F")
test = pd.read_excel(path, usecols="G")

output = input.copy()
output['min_product'] = input.apply(lambda row: min(np.prod(c) for c in combinations(row, 3)), axis=1).astype(np.int64)

print(output["min_product"].equals(test["Answer Expected"])) # True