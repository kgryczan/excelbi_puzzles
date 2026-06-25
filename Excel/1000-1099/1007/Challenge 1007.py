import pandas as pd
import re

path = "1000-1099/1007/1007 String Processing.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=10, skiprows=0)
test = pd.read_excel(path, usecols="D", nrows=10, skiprows=0)


def solve(t, p, d):
    t = "" if pd.isna(t) else str(t)
    p = list(map(int, re.findall(r"\d+", str(p))))
    d = set("" if pd.isna(d) else str(d))
    res = []
    i = k = 0
    while i < len(t):
        n = p[k % len(p)]
        c = t[i : i + n]
        r = len(c) % 2 == 0
        c = c[::-1] if r else c
        c = "".join(x for x in c if x not in d)
        if not r and len(c) % 2 == 0:
            c = c[::-1]
        res.append(c)
        i += n
        k += 1
    return "".join(res[::-1])


input["Answer Expected"] = input.apply(
    lambda r: solve(r["Text"], r["Pattern"], r["Dropset"]), axis=1
)

print(input["Answer Expected"].equals(test["Answer Expected"]))
# True
