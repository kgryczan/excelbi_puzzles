import pandas as pd

path = "Excel/900-999/907/907 Olympics Ranking.xlsx"
input = pd.read_excel(path, usecols="A:E", skiprows=1, nrows=100)
test = pd.read_excel(path, usecols="G:K", skiprows=1, nrows=10).rename(columns=lambda x: x.replace(".1", ""))

result = (input.groupby(["Country", "Medal"], as_index=False).size()
    .pivot(index="Country", columns="Medal", values="size").fillna(0).reset_index()
    .rename_axis(None, axis=1))

for medal in ["Gold", "Silver", "Bronze"]:
    result[medal] = result.get(medal, 0)

result = (result.assign(
        score=lambda df: df["Gold"] * 1e6 + df["Silver"] * 1e3 + df["Bronze"],
        Rank=lambda df: df["score"].rank(method="dense", ascending=False).astype(int))
    .sort_values(by=["Gold", "Silver", "Bronze"], ascending=[False] * 3)
    .loc[:, ["Rank", "Country", "Gold", "Silver", "Bronze"]]
    .reset_index(drop=True)
    .astype({"Gold": "int64", "Silver": "int64", "Bronze": "int64"}))

print(result.equals(test))  # True
