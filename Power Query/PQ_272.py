import pandas as pd

path = "PQ_Challenge_272.xlsx"

input = pd.read_excel(path, usecols="A:F", nrows=5)
test = pd.read_excel(path, usecols="H:N", nrows=8).rename(columns=lambda x: x.split(".")[0])

result = (
    input.melt(id_vars=["Date"], var_name="Attribute", value_name="Value")
    .dropna(subset=["Value"])
    .assign(Value=lambda df: df["Value"].str.split(", "))
    .explode("Value")
    .assign(RowNumber=lambda df: df.groupby(["Date", "Attribute"]).cumcount() + 1)
    .pivot(index=["Date", "RowNumber"], columns="Attribute", values="Value")
    .reset_index()
    .sort_values(by=["RowNumber", "Date"])
    .drop(columns=["RowNumber"])
    .reset_index(drop=True)
)
result.columns.name = None
result.insert(0, "Seq", result.index + 1)

print(result.equals(test)) # True