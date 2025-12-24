import pandas as pd

path = "Excel\\800-899\\876\\876 Running Total.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows = 51)
test = pd.read_excel(path, usecols="C", nrows = 51)

g = input["Value"].ne(input["Value"].shift()).cumsum()
input["running_total"] = (
    input["Value"]
    + (input["Value"] % 2) * (input.groupby(g).cumcount())
    - (input["Value"] % 2 == 0) * 2 * (input.groupby(g).cumcount())
).cumsum()

print(input["running_total"].equals(test["Answer Expected"])) # True