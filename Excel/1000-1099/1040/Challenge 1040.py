import numpy as np
import pandas as pd

path = "1000-1099/1040/1040 Largest Gap and Anomaly.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=8, skiprows=1)
test = pd.read_excel(path, usecols="C:D", nrows=8, skiprows=1)


def gap(s, target):
    p = [i for i, x in enumerate(map(int, s.split(", ")), 1) if x == target]
    if len(p) < 2:
        return pd.Series([np.nan, np.nan], dtype="float64")
    d = np.diff(p) - 1
    i = d.argmax()
    return pd.Series([d[i], p[i + 1]], dtype="float64")


input[["Distance", "Anomaly"]] = input.apply(
    lambda x: gap(x["Sequence"], x["Target"]), axis=1
)

result = input[["Distance", "Anomaly"]]
result.columns = ["Largest Gap", "Anomaly Position"]
print(result.equals(test))
