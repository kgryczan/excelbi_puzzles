import pandas as pd

path = "1000-1099/1044/1044 Lexographical Smallest Rotation.xlsx"
input = pd.read_excel(path, usecols="A", nrows=10)
test = pd.read_excel(path, usecols="B", nrows=10)


def rotate(x, n):
    return x[n:] + x[:n]


def min_rotation(x):
    return min(rotate(x, i) for i in range(len(x)))


result = (
    input.assign(rn=lambda x: range(len(x)))
    .assign(Data=lambda x: x["Data"].str.split(" "))
    .explode("Data")
    .assign(min_rotation=lambda x: x["Data"].map(min_rotation))
    .groupby("rn", as_index=False)["min_rotation"]
    .agg(lambda x: " ".join(sorted(x)))
    .rename(columns={"min_rotation": "result"})
)

print(result["result"].equals(test["Answer Expected"]))
# True
