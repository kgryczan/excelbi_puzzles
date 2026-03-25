import pandas as pd

input_data = pd.read_excel("PQ_Challenge_166.xlsx", usecols="A:C", nrows=14)
test = pd.read_excel("PQ_Challenge_166.xlsx", usecols="E:H", nrows=5)

result = input_data.copy()
result["Tracking No"] = result["Tracking No"].ffill()
result["group"] = result["Tracking No"].str.match(r"^[A-Z]").cumsum()
result = (
    result.groupby("group", as_index=False)
    .agg(
        TrackingNo=("Tracking No", lambda s: ", ".join(pd.unique(s))),
        ItemCount=("Items", lambda s: s.dropna().nunique()),
        TotalAmount=("Amount", lambda s: s.fillna(0).sum()),
    )
)
split = result["TrackingNo"].str.split(", ", expand=True)
result["Company"] = split[0]
result["Trackng No"] = pd.to_numeric(split[1])
result = result[["Company", "Trackng No", "ItemCount", "TotalAmount"]].rename(columns={"ItemCount": "Item Count", "TotalAmount": "Total Amount"}).sort_values("Company").reset_index(drop=True)

print((test == result).all().all())
