import pandas as pd
import numpy as np

path = "Power Query/300-399/358/PQ_Challenge_358.xlsx"
input = pd.read_excel(path, usecols="A:E", nrows=21)
test = pd.read_excel(path, usecols="G:H", nrows=9).rename(columns=lambda x: x.replace('.1', ''))

prices = (
    input[["Price"]]
    .assign(Price=lambda d: d["Price"].str.split(";"))
    .explode("Price")
    .assign(tmp=lambda d: d["Price"].str.split("=", n=1))
    .assign(
        Code=lambda d: d["tmp"].str[0],
        Price=lambda d: d["tmp"].str[1].astype(float)
    )
    .drop(columns="tmp")
    .drop_duplicates()
    .sort_values("Code")
)

orders = (
    input[["OrderID", "Customer", "Items"]]
    .assign(Items=lambda d: d["Items"].str.split(";"))
    .explode("Items")
    .assign(
        Outside=lambda d: np.where(
            d["Items"].str.contains(r"\[.*\]"),
            d["Items"].str.replace(r"\[.*\]", "", regex=True),
            np.nan
        ),
        Inside=lambda d: np.where(
            d["Items"].str.contains(r"\[.*\]"),
            d["Items"].str.extract(r"(\[.*\])")[0],
            d["Items"]
        )
    )
    .assign(Inside=lambda d: d["Inside"].str.replace(r"[\[\]]", "", regex=True))
    .assign(Inside=lambda d: d["Inside"].str.split(r"\+"))
    .explode("Inside")
    .assign(tmp=lambda d: d["Inside"].str.split("*", n=1))
    .assign(
        Code=lambda d: d["tmp"].str[0],
        Quantity=lambda d: d["tmp"].str[1].astype(float)
    )
    .drop(columns=["tmp", "Items", "Inside"])
)
result = (
input[["OrderID", "Customer", "DiscountCode"]]
.merge(orders, on=["OrderID", "Customer"], how="left")
.merge(prices, on="Code", how="left")
.assign(Amount=lambda d: d["Quantity"] * d["Price"])
.assign(
discount=lambda d: np.select(
[d["DiscountCode"].eq("DISC5"), d["DiscountCode"].eq("DISC10")],
[0.05, 0.10],
default=0.0
),
all_discount=lambda d: np.select(
[
d["Outside"].eq("BNDL"),
d["Outside"].eq("RET"),
d["Outside"].eq("NONE"),
d["Outside"].eq("FREE"),
],
[
1 - d["discount"] - 0.1,
-1,
1 - d["discount"],
0,
],
default=1 - d["discount"]
)
)
.assign(Total=lambda d: d["Amount"] * d["all_discount"])
.groupby("Customer", as_index=False)["Total"]
.sum()
.rename(columns={"Total": "Total Amount"})
)


print(result.equals(test))
# one dicrepancy found