import pandas as pd

path = "1000-1099/1003/1003 String Processing.xlsx"
input = pd.read_excel(path, usecols="A", nrows=20, skiprows=0)
test = pd.read_excel(path, usecols="B", nrows=20, skiprows=0)


def process_string(commands: str) -> str:
    ops = {
        "#": lambda s: s[:-1],
        "~": lambda s: s[::-1],
        "*": lambda s: s * 2,
        "^": lambda s: s.translate(str.maketrans("", "", "AEIOU")),
        "%": lambda s: s[-1:] + s[:-1],
    }
    s = ""
    for c in commands:
        s = s + c if "A" <= c <= "Z" else ops[c](s) if c in ops else s
    return s


result = [process_string(cmd) for cmd in input["Input"]]
print(result == test["Answer Expected"].tolist())
# True
