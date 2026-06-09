import pandas as pd

path = "900-999/995/995 Next Greater Distance.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=21, skiprows=0)
test = pd.read_excel(path, usecols="D", nrows=21, skiprows=0)


def find_next_greater(x, i):
    return next((d for d in range(1, len(x)) if x[(i + d) % len(x)] > x[i]), 0)


result = input.copy()
result["Output"] = result.groupby("Group")["Value"].transform(
    lambda g: [find_next_greater(g.to_numpy(), i) for i in range(len(g))]
)

print(result["Output"].equals(test["Answer Expected"]))
# True
