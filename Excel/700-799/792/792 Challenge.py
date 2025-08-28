import pandas as pd
import string

path = "700-799/792/792 Sorting as per Last Letter.xlsx"
input = pd.read_excel(path, usecols="A", nrows=27).squeeze()
test = pd.read_excel(path, usecols="B", nrows=27).squeeze()

def chain_sort(words):
    seed, pool, out = "Apple", [w for w in words if w != "Apple"], ["Apple"]
    abc = string.ascii_lowercase
    while pool:
        last = out[-1][-1].lower()
        order = abc[abc.index(last):] + abc[:abc.index(last)]
        firsts = [w[0].lower() for w in pool]
        idx = next(firsts.index(c) for c in order if c in firsts)
        out.append(pool.pop(idx))
    return out

result = chain_sort(input)
print((result == test).all()) # True