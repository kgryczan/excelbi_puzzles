import pandas as pd

path = "Excel/800-899/854/854 Sum of Digits Min and Max.xlsx"
input = pd.read_excel(path, usecols="A:B", skiprows=1, nrows=9)
test = pd.read_excel(path, usecols="C:D", skiprows=1, nrows=9)

def max_num(n, s):
    if s < 9:
        m = str(s) + "0" * (n - 1)
    else:
        digits = []
        while s > 9:
            digits.append(9)
            s -= 9
            n -= 1
        m = "".join(str(d) for d in digits) + str(s) + "0" * (n - 1)
    return m

def min_num(n, s):
    if s < 9:
        m = "1" + "0" * (n - 2) + str(s - 1)
    else:
        digits = []
        s -= 1
        while s > 9:
            digits.append(9)
            s -= 9
            n -= 1
        digits.append(s)
        n -= 1
        m = "1" + "0" * (n - 1) + "".join(str(d) for d in digits[::-1])
    return m

results = input.copy()
results["Min Number"] = results.apply(lambda row: int(min_num(row["Number of Digits"], row["Sum of Digits"])), axis=1)
results["Max Number"] = results.apply(lambda row: int(max_num(row["Number of Digits"], row["Sum of Digits"])), axis=1)
results = results[["Min Number", "Max Number"]]

print(results.equals(test)) # One difference found