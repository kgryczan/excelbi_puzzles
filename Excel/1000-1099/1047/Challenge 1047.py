import pandas as pd

path = "1000-1099/1047/1047 Cryptographic Challenge.xlsx"
input = pd.read_excel(path, usecols="A", nrows=9)
test = pd.read_excel(path, usecols="B", nrows=9)


def f(s):
    x = s[::2][::-1] + s[1::2]
    return "".join(chr((ord(c) - 65 + i) % 26 + 65) for i, c in enumerate(x, 1))


input["Answer Expected"] = input["Message"].map(f)

print(input["Answer Expected"].equals(test["Answer Expected"]))
# True
