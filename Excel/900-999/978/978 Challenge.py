import pandas as pd

path = "900-999/978/978 Leader Cumulative Basis.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=29, skiprows=0)
test = pd.read_excel(path, usecols="D", nrows=29, skiprows=0)

result = input.copy()
result["cust_cumsum"] = result.groupby("Customer")["Amount"].cumsum()
result["Answer Expected"] = result["cust_cumsum"].cummax().eq(result["cust_cumsum"]).astype(int)

print(result["Answer Expected"].equals(test["Answer Expected"]))
# True
