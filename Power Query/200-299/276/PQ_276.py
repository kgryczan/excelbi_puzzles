import pandas as pd

path = "PQ_Challenge_276.xlsx"
input = pd.read_excel(path, usecols="A:I", nrows=4)
test = pd.read_excel(path, usecols="A:F", skiprows=8, nrows=10)

input_long = pd.wide_to_long(
    input.reset_index(),
    stubnames=["Item", "Qty", "Price"],
    i=["index", "Order ID", "Shipping"],
    j="name",
    sep="",
    suffix="\d+"
).reset_index()
input_long["Item"] = input_long["Item"].ffill()
input_long = input_long.dropna().reset_index(drop=True)

input_long = input_long.drop(columns=["name"]).rename(columns={"Item1": "Item"})

input_long["TotalValue"] = input_long["Qty"] * input_long["Price"]
input_long[["Order ID", "Qty", "Price"]] = input_long[["Order ID", "Qty", "Price"]].astype(str)

totals = (
    input_long.groupby("Item", as_index=False)
    .agg(
        Shipping=("Shipping", "first"),
        TotalValue=("TotalValue", "sum")
    )
)
totals["TotalValue"] += totals["Shipping"]
totals = totals.assign(
    Order_ID="TOTAL",
    index=None,
    Shipping=None,
    Qty=None,
    Price=None
).rename(columns={"Order_ID": "Order ID"})

result = (
    pd.concat([input_long, totals], ignore_index=True)
    .sort_values(by="Item")
    .assign(Item=lambda df: df["Item"].where(df["Order ID"] != "TOTAL", pd.NA))
    .drop(columns=["index"])
    .reset_index(drop=True)
)

