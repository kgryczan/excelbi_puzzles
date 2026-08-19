import re

import pandas as pd

path = "1000-1099/1045/1045 Repeating Sequence.xlsx"
input = pd.read_excel(path, usecols="A:C", skiprows=1, nrows=34)
test = pd.read_excel(path, usecols="E:F", skiprows=1, nrows=5)
test.columns = ["CustomerID", "RepeatingSequence"]


def repeats(x):
    hits = [
        (len(m[0]), i)
        for i in range(len(x))
        if (m := re.match(r"(.+?)\1+", "".join(x[i:])))
    ]
    chosen = []
    for length, start in sorted(hits, reverse=True):
        if not any(start < s + l and s < start + length for l, s in chosen):
            chosen.append((length, start))
    return ", ".join(
        "-".join(x[s : s + l]) for l, s in sorted(chosen, key=lambda z: z[1])
    )


result = (
    input.groupby("CustomerID", sort=False)
    .Product.apply(lambda x: repeats(x.tolist()))
    .reset_index(name="RepeatingSequence")
)
print(result.equals(test.fillna({"RepeatingSequence": ""})))
