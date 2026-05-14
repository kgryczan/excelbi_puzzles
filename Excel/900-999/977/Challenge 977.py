import pandas as pd
     
path = "900-999/977/977 Balanced Brackets.xlsx"
input = pd.read_excel(path, usecols="A", nrows=21, skiprows=1)
test = pd.read_excel(path, usecols="B:C", nrows=21, skiprows=1)

def solve(s):
    if len(s) % 2 or s.count("(") != s.count(")"):
        return -1, "Impossible"
    bal = 0
    low = 0
    for c in s:
        bal += 1 if c == "(" else -1
        low = min(low, bal)
    swaps = (-low + 1) // 2
    if swaps == 0:
        return 0, s
    x = list(s)
    for _ in range(swaps):
        i = x.index(")")
        j = len(x) - 1 - x[::-1].index("(")
        x[i], x[j] = x[j], x[i]
    return swaps, "".join(x)

# Apply solve function to input
results = input.apply(lambda row: pd.Series(solve(row[0])), axis=1)
results.columns = ["Swaps", "Corrected"]
print(results)

