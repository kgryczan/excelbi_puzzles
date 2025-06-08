import pandas as pd

path = "200-299/294/PQ_Challenge_294.xlsx"
input = pd.read_excel(path, usecols="A", nrows=12, names=["Data"])
test = pd.read_excel(path, usecols="C:F", nrows=3)

result = (
    input[input["Data"].str.contains("Group", na=False)]
    .Data.str.split(" - ", expand=True)
    .rename(columns={0: "Group", 1: "Item", 2: "Value"})
    .assign(
        Group=lambda df: df["Group"].str.replace("Group ", "", regex=False),
        Value=lambda df: pd.to_numeric(df["Value"], errors="coerce")
    )
    .pivot_table(index="Group", columns="Item", values="Value", aggfunc="sum")
    .reset_index()
)

result = result[["Group"] + sorted([col for col in result.columns if col != "Group"])]
result = result.sort_values("Group").reset_index(drop=True)
result.columns.name = None

# Expected output - incorrect