import pandas as pd

path = "1000-1099/1042/1042 Stack Processing.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=14)
test = pd.read_excel(path, usecols="C", nrows=14, dtype="str")


def collapse(x, m):
    s = []
    for v in x:
        s.append(v)
        while len(s) > 1 and s[-1] % m == s[-2] % m:
            s[-2:] = [s[-2] + s[-1]]
    return s


input["Result"] = input.apply(
    lambda x: " ".join(map(str, collapse(map(int, x["Tokens"].split()), x["Modulus"]))),
    axis=1,
)

print(input["Result"].equals(test["Answer Expected"]))
# True
