import pandas as pd

path = "700-799/765/765 Pivot.xlsx"

input = pd.read_excel(path, usecols="A:B", skiprows=1, nrows=8)
test = pd.read_excel(path, usecols="D:H", skiprows=1, nrows=3).rename(columns=lambda x: x.rstrip(".1"))

input = (
    input.assign(Items=input["Items"].str.split(", "))
    .explode("Items")
    .assign(
        Item=lambda df: df["Items"].str.split(": ").str[0],
        Quantity=lambda df: pd.to_numeric(df["Items"].str.split(": ").str[1])
    )
    .drop(columns=["Items"])
    .pivot_table(index="Supplier", columns="Item", values="Quantity", aggfunc="sum", fill_value=0)
    .reset_index()
)

sorted_columns = ["Supplier"] + sorted([col for col in input.columns if col != "Supplier"])
result = input[sorted_columns]
result.index.name = None

# DFs are not equal