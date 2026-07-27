import pandas as pd
from itertools import groupby

path = "1000-1099/1029/1029 Running Characters Encoding Sorting.xlsx"
input = pd.read_excel(path, usecols="A", nrows=21)
test = pd.read_excel(path, usecols="A:B", nrows=21)


def encode(text):
    runs = [(char, len(list(group))) for char, group in groupby(text)]
    encoded = "".join(f"{char}{count}" for char, count in sorted(
        [run for run in runs if run[1] >= 3], key=lambda run: -run[1]
    ))
    remaining = "".join(char * count for char, count in runs if count < 3)
    return encoded + remaining


result = input.assign(**{"Answer Expected": input["Text"].map(encode)})
print(result.equals(test))
# True
