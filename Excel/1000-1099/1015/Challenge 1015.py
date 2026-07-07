import pandas as pd
import operator as op

path = "1000-1099/1015/1015 Logic Gates.xlsx"
input = pd.read_excel(path, usecols="A:D", nrows=21)
test = pd.read_excel(path, usecols="E", nrows=21)


f = {
    "AND": op.and_,
    "OR": op.or_,
    "XOR": op.xor,
    "NOT": lambda x, y=None: not x,
    "NAND": lambda x, y: not (x and y),
    "NOR": lambda x, y: not (x or y),
    "XNOR": lambda x, y: not (x ^ y),
}

v = {}


def val(x):
    return bool(int(x)) if str(x) in ("0", "1") else v[x]


input["Result"] = [
    int(v.setdefault(g, f[t](val(x), None if pd.isna(y) else val(y))))
    for g, t, x, y in input[["Gate", "Type", "Input1", "Input2"]].itertuples(
        index=False
    )
]

print(input["Result"].equals(test["Answer Expected"]))
# True
