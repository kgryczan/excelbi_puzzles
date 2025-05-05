import pandas as pd
import re

path = "700-799/709/709 Filter Out Repeats.xlsx"

input = pd.read_excel(path, usecols="A:B", skiprows=1, nrows=9)
test = pd.read_excel(path, usecols="C:D", skiprows=1, nrows=6).rename(columns=lambda x: re.sub(r"\.1$", "", x))

def extract_distinct_uppercase(s):
    return len(set(re.findall(r"[A-Z]", s)))

filtered = input.groupby("Data2").filter(
    lambda group: not (
        extract_distinct_uppercase(group.name) == 1 and
        len(group.name) != 1 and
        len(group) == 2
    )
).reset_index(drop=True)
result = filtered[["Data1", "Data2"]]

print(result.equals(test)) # True