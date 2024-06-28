import pandas as pd
from itertools import combinations
import pandas as pd

path = "488 Numbers to Meet Target Sum.xlsx"
input = pd.read_excel(path, usecols="A")
target = pd.read_excel(path, usecols="B", nrows = 1).iloc[0,0]
test  = pd.read_excel(path, usecols="C", nrows = 4)

def find_combinations(numbers, target):
    combs = []
    for i in range(1, len(numbers) + 1):
        combs.extend(combinations(numbers, i))
    
    valid_combs = []
    for comb in combs:
        if sum(comb) == target:
            valid_combs.append(comb)
    
    return pd.DataFrame(valid_combs)

results = find_combinations(input["Numbers"], target)
results = results.apply(lambda x: ", ".join([str(int(i)) for i in x if pd.notnull(i)]), axis=1)

def sort_numbers(x):
    if isinstance(x, str):
        return ", ".join(sorted([str(i) for i in x.split(", ")]))
    else:
        return x

results = results.apply(sort_numbers)
test = test.applymap(sort_numbers) 

print(results.equals(test["Answer Expected"])) # True