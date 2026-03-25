import pandas as pd

input_data = pd.read_excel("PQ_Challenge_147.xlsx", usecols="A:D", nrows=17)
test = pd.read_excel("PQ_Challenge_147.xlsx", usecols="F:I", nrows=17)
test.columns = [c.strip().lower() for c in test.columns]

result = input_data.copy()
result.columns = [c.strip().lower() for c in result.columns]
result["nr"] = range(1, len(result) + 1)
for col in ["cust_id", "cust_name", "amount", "type"]:
    result[f"index_{col}"] = result[col].notna().cumsum().where(result[col].notna())
result["max_index"] = result[[f"index_{c}" for c in ["cust_id", "cust_name", "amount", "type"]]].max(axis=1)

agg = (
    result.groupby("max_index", dropna=True)
    .agg(
        cust_id=("cust_id", "max"),
        cust_name=("cust_name", "max"),
        amount=("amount", "max"),
        type=("type", "max"),
        min_row=("nr", "min"),
        max_row=("nr", "max"),
    )
    .reset_index(drop=True)
)
rows = []
for _, row in agg.iterrows():
    for seq in range(int(row["min_row"]), int(row["max_row"]) + 1):
        rows.append({
            "cust_id": row["cust_id"],
            "cust_name": row["cust_name"],
            "amount": row["amount"],
            "type": row["type"],
            "row_seq": seq,
        })
result2 = pd.DataFrame(rows).drop(columns="row_seq")
result2["type"] = result2.groupby("cust_id").cumcount().add(1).astype(str).radd(result2["type"])

print(result2.equals(test))
