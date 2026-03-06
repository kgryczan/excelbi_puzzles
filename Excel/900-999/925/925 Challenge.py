import pandas as pd
import re

path = "900-999/925/925 Max Order.xlsx"
input1 = pd.read_excel(path, usecols="A:C", nrows=7)
input2 = pd.read_excel(path, usecols="E:F", nrows=3)
test = pd.read_excel(path, usecols="G", nrows=3)

i1 = input1.ffill()
mains = i1[i1["Category"] == "Mains"]
dnd = i1[i1["Category"] != "Mains"]
dnd = pd.concat(
    [dnd, pd.DataFrame([{"Category": "DND", "Item": "", "Price": 0}])],
    ignore_index=True
)
deal = (
    pd.MultiIndex.from_product([mains["Item"], dnd["Item"]], names=["Var1", "Var2"])
    .to_frame(index=False)
)
deal = (
    deal.merge(i1, left_on="Var1", right_on="Item", how="left")
        .merge(i1, left_on="Var2", right_on="Item", how="left", suffixes=(".x", ".y"))
)
deal["deal"] = (
    deal["Var1"].fillna("") + ", " + deal["Var2"].fillna("")
).str.replace(", $", "", regex=True).str.replace("^, ", "", regex=True)
deal["price"] = deal["Price.x"] + deal["Price.y"].fillna(0)
deal = deal[["deal", "price"]]

result = (
    input2.merge(deal, how="cross")
          .query("price <= Amount")
          .sort_values("price")
          .groupby("Name")
          .tail(1)[["deal"]]
          .rename(columns={"deal": "Answer Expected"})
          .sort_index()
          .reset_index(drop=True))

print(result.equals(test))
# True