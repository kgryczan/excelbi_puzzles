import pandas as pd

path = "300-399/382/PQ_Challenge_382.xlsx"
input = pd.read_excel(path, usecols="A:D", nrows=22, skiprows=0)
test = pd.read_excel(path, usecols="G:H", nrows=2, skiprows=0)

joined = (
    input
    .merge(input, left_on="Component", right_on="Parent Assembly", how="left", suffixes=(".x", ".y"))
    .merge(input, left_on="Component.y", right_on="Parent Assembly", how="left", suffixes=("", ".y2"))
    .loc[lambda df: ~(
        df["Component.x"].isin(df["Component.y"]) |
        df["Component.x"].isin(df["Component"])
    )]
    .assign(
        Unit_Cost=lambda df: df["Unit Cost.x"]
            .combine_first(df["Unit Cost.y"])
            .combine_first(df["Unit Cost"]),
        Quantity=lambda df:
            df["Qty.x"].fillna(1)
            * df["Qty.y"].fillna(1)
            * df["Qty"].fillna(1)
    )
    .assign(Total_Cost=lambda df: df["Unit_Cost"] * df["Quantity"])
    .groupby("Parent Assembly.x", as_index=False)["Total_Cost"].sum()
    .astype({"Total_Cost": "int64"})
    .rename(columns={
       "Parent Assembly.x": "Top Level Product",
        "Total_Cost": "Total Cost"
    })
)
print(joined.equals(test))
# True