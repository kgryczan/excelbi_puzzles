import pandas as pd

path = "Excel/800-899/871/871 Ranking of Hockey Winners Decade-wise.xlsx"
input_df = pd.read_excel(path, sheet_name=0, usecols="A:D", skiprows=1, nrows=89)
test_df = pd.read_excel(path, sheet_name=0, usecols="F:I", skiprows=1, nrows=11)

result = (
    input_df
    .melt(id_vars="Year", var_name="Medal", value_name="Country")
    .assign(
        Decade=lambda df: (df["Year"] // 10 * 10).astype(str) + "-" + (df["Year"] // 10 * 10 + 9).astype(str),
        Medal_value=lambda df: df["Medal"].map({"Gold": 3, "Silver": 2, "Bronze": 1})
    )
    .groupby(["Decade", "Country"], as_index=False)
    .agg(Total=("Medal_value", "sum"))
    .assign(rank=lambda df: df.groupby("Decade")["Total"].rank(method="dense", ascending=False).astype(int))
    .query("rank <= 3")
    .sort_values(["Decade", "rank", "Country"])
    .groupby(["Decade", "rank"], as_index=False)
    .agg(Country=("Country", ", ".join))
    .pivot(index="Decade", columns="rank", values="Country")
    .rename(columns={1: "Rank1", 2: "Rank2", 3: "Rank3"})
    .reset_index()
    .reindex(columns=["Decade", "Rank1", "Rank2", "Rank3"])
)

print(result.equals(test_df))