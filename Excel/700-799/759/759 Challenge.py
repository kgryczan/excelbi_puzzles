import pandas as pd

path = "700-799/759/759 Lookup Value.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=5)
test = pd.read_excel(path, usecols="C", nrows=5)

def extract(s, letters):
    d = dict(x.split(":") for x in s.split(", "))
    return [d[k] for k in letters.split(", ")]

input["extracted"] = input.apply(lambda r: ", ".join(extract(r["String"], r["Letter"])), axis=1)
result = input["extracted"]

# one discrepancy: Pi is not the same as Phi.