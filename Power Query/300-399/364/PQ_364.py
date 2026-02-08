import pandas as pd

path = "Power Query/300-399/364/PQ_Challenge_364.xlsx"
input = pd.read_excel(path, usecols="A", nrows=51)
test = pd.read_excel(path, usecols="C:F", nrows=12).rename(columns={"Total Sales": "Total_Sales"})

input = input["OrderID,OrderDate,Customer,Items"].str.split(",", expand=True)
input.columns = ["OrderID", "OrderDate", "Customer", "Items"]

items_expanded = input.pop("Items").str.split(";", expand=True).stack().reset_index(level=1, drop=True)
items_expanded = items_expanded.str.split(":", expand=True)
items_expanded.columns = ["Item", "Quantity", "Price"]

input = input.join(items_expanded).reset_index(drop=True)
input["OrderDate"] = pd.to_datetime(input["OrderDate"])
input["Quantity"] = pd.to_numeric(input["Quantity"])
input["Price"] = pd.to_numeric(input["Price"])
input["Quarter"] = "Q" + input["OrderDate"].dt.quarter.astype(str)
input["Sales"] = input["Quantity"] * input["Price"]

result = (input
          .groupby(["Customer", "Quarter"], as_index=False)
          .agg(Total_Sales=("Sales", "sum")))
result["Rank"] = result.groupby("Quarter")["Total_Sales"].rank(method="dense", ascending=False).astype(int)
result = (result[result["Rank"] <= 3]
          .sort_values(["Quarter", "Rank"])
          .reset_index(drop=True)[["Quarter", "Customer", "Total_Sales", "Rank"]])

print(result.equals(test))
# Some inequalities related to floating point precision, but the result is correct.