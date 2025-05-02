import pandas as pd

path = '539 Total Amount Per Item.xlsx'
input1 = pd.read_excel(path, usecols="A:F", skiprows=1, nrows=9)
input2 = pd.read_excel(path, usecols="H:I", skiprows=1, nrows=8)
test = pd.read_excel(path, usecols="J", skiprows=1, nrows=8)
input2.columns = input2.columns.str.replace(".1", "")

r1 = input1.melt(id_vars=["Item", "Supplier"], var_name="Range", value_name="Price")
r2 = input2.assign(Range=pd.cut(input2["Quantity"], bins=[0, 5, 10, 20, float("inf")], labels=["0-5", "6-10", "11-20", "20+"]))
r3 = r2.merge(r1, on=["Item", "Range"])\
        .groupby(["Item", "Quantity"]).agg(avg_price=("Price", "mean")).reset_index()\
        .assign(Amount=lambda x: round(x["Quantity"] * x["avg_price"], 1))
print(r3["Amount"].equals(test["Amount"])) # True
