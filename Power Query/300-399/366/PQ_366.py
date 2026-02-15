import pandas as pd

path = "Power Query/300-399/366/PQ_Challenge_366.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=46)
test = pd.read_excel(path, usecols="D:J", nrows=10).fillna("")

result = (
    input
    .assign(order_grp=lambda d: (d["Attribute"] == "Order ID").cumsum())
    .assign(sub_id=lambda d: d.groupby("order_grp")["Attribute"]
            .transform(lambda s: (s == "Customer").cumsum()))
    .pivot_table(
        index=["order_grp", "sub_id"],
        columns="Attribute",
        values="Value",
        aggfunc="first"
    )
    .reset_index()
    .sort_values(["order_grp", "sub_id"])
    .rename(columns={"sub_id": "Sub Order ID"})
    .loc[:, ["Order ID", "Sub Order ID", "Customer", "Date", "Region", "Priority", "Status"]]
    .assign(**{"Order ID": lambda d: d["Order ID"].ffill().astype(str)})
    .query("`Sub Order ID` != 0")
    .fillna("")
    .reset_index(drop=True)
)

print(result.equals(test))
# Sub Order ID in ORD-105 should be 1 not 2.