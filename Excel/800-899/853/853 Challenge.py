import pandas as pd

path = "Excel/800-899/853/853 Collatz Sequence.xlsx"
input = pd.read_excel(path, usecols="A", skiprows=1, nrows=8)
test = pd.read_excel(path, usecols="B", skiprows=1, nrows=8)

collatz_steps = lambda n: 0 if n == 1 else 1 + collatz_steps(3 * n + 1 if n % 2 else n // 2)
input["Steps"] = input.iloc[:, 0].apply(collatz_steps)

print(input["Steps"].equals(test["Steps"]))
# True