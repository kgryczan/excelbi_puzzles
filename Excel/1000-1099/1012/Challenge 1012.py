import pandas as pd

path = "1000-1099/1012/1012 Vowel Replacement by Index.xlsx"
input = pd.read_excel(path, usecols="A", nrows=11, skiprows=0)
test = pd.read_excel(path, usecols="B", nrows=11, skiprows=0)

v = "aeiou"
V = v.upper()


def f(s):
    vowel_index = 0
    replaced = []
    for c in s:
        if c in v + V:
            replacement_set = V if c.isupper() else v
            replaced.append(replacement_set[vowel_index % 5])
            vowel_index += 1
        else:
            replaced.append(c)
    return "".join(replaced)


result = input.assign(result=input.iloc[:, 0].astype(str).apply(f))
