import pandas as pd
import numpy as np
import itertools
import re

path = "Excel/800-899/887/887 Minimum Product Triplet.xlsx"
input = pd.read_excel(path, usecols="A", skiprows=1, nrows=20)
test = pd.read_excel(path, usecols="B:C", skiprows=1, nrows=20)
test = test.applymap(lambda x: re.sub(r'\{', '(', str(x)))
test = test.applymap(lambda x: re.sub(r'\}', ')', str(x)))

def find_triplet(s):
    x = list(map(int, s.split(", ")))
    combs = list(itertools.combinations(x, 3))
    prods = [np.prod(c) for c in combs]
    m = min(prods)
    min_triplets = [tuple(sorted(combs[i])) for i, p in enumerate(prods) if p == m]
    unique_triplets = sorted(set(min_triplets), key=lambda t: sum(t))
    triplet_strs = [", ".join(map(str, t)) for t in unique_triplets]
    triplets_fmt = "(" + ") , (".join(triplet_strs) + ")"
    return {"Min Product": str(m), "Triplets": triplets_fmt}

result = pd.DataFrame([find_triplet(s) for s in input.iloc[:,0]])

print(result.equals(test))
# FALSE, two cells has wrong min product in solution. And there is some sorting problems