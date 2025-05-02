import pandas as pd

input1 = pd.read_excel("476 Assigning Sales.xlsx", usecols="A:B", skiprows=1, nrows = 3 )
input2 = pd.read_excel("476 Assigning Sales.xlsx", usecols="D:E", skiprows=1) 
input2.columns = ["Store", "Branch"]
test = pd.read_excel("476 Assigning Sales.xlsx", usecols="G:I", skiprows=1)
test.columns = ["Store", "Branch", "Sales"]

result = pd.merge(input1, input2, on="Store", how="left")
result["n"] = result.groupby("Store")["Store"].transform("count")
result["Sales"] = result["Sales"] / result["n"]
result["Sales"] = result["Sales"].astype('int64')
result = result[["Store", "Branch", "Sales"]]

print(result.equals(test)) # True