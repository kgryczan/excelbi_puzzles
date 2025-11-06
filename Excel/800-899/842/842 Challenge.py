import pandas as pd

path = "Excel/800-899/842/842 Running Total.xlsx"
input = pd.read_excel(path, usecols="A:C", skiprows=1, nrows=22)
test = pd.read_excel(path, usecols="D", skiprows=1, nrows=22)

input["Running Total"] = input.groupby("Company")["Revenue"].cumsum()
result = input

print(result["Running Total"].equals(test["Running Total"]))  # True