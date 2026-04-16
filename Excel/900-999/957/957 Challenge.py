import pandas as pd
import re

path = "900-999/957/957 Split.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=10, skiprows=0)
test = pd.read_excel(path, usecols="C", nrows=10, skiprows=0)

def split_string(data, rules):
    if pd.isna(rules) or rules == "(none)":
        return data
    tokens = [t.strip() for t in rules.split(",")]
    cut_points = set()
    for tok in tokens:
        if tok.startswith("@"):
            fn = {"@DIGIT": str.isdigit, "@UPPER": str.isupper, "@ALPHA": str.isalpha}.get(tok)
            if fn:
                cut_points.update(i for i, ch in enumerate(data) if fn(ch))
        else:
            pos = int(tok)
            cut_points.add(pos)
    cut_points.update([0, len(data)])
    cuts = sorted(cut_points)
    parts = [data[cuts[i]:cuts[i+1]] for i in range(len(cuts)-1)]
    parts = [p for p in parts if p]
    
    return " | ".join(parts)

input["Answer"] = input.apply(lambda row: split_string(row["Data"], row["Split_Rules"]), axis=1)
print(input["Answer"].equals(test["Answer Expected"]))
# True 