import pandas as pd

input = pd.read_excel("PQ_Challenge_172.xlsx", usecols="A:F", nrows = 10)
test = pd.read_excel("PQ_Challenge_172.xlsx", usecols="H:I", nrows = 5)

r1 = input.copy()
r1["share_percent"] = r1["Share %"].fillna("100")
r1 = r1.assign(share_percent=r1["share_percent"].str.split(", ")).explode("share_percent")
r1["nr"] = r1.groupby("Item").cumcount() + 1
r1["Agent"] = r1.apply(lambda x: x["Agent1"] if x["nr"] == 1 else x["Agent2"], axis=1)
r1["Commission"] = r1["Amount"] * r1["share_percent"].astype(float) / 100 * r1["Commission %"] / 100

top = r1.groupby("Agent").agg(Commission=("Commission", "sum")).round(0).astype(int).reset_index()
total = top.agg(Commission=("Commission", "sum")).reset_index()
total["Agent"] = "Total"

result = pd.concat([total[["Agent", "Commission"]], top[["Agent", "Commission"]]]).sort_values("Agent").reset_index(drop=True)

print(result.equals(test)) # True