import pandas as pd

path = "708 Repeat Names and Quarters.xlsx"

input = pd.read_excel(path, sheet_name=0, usecols="A:E", skiprows=1, nrows=4)
test = pd.read_excel(path, sheet_name=0, usecols="G:H", skiprows=1, nrows=16).rename(columns=lambda x: x.replace(".1", ""))

input["Names"] = pd.Categorical(input["Names"], categories=input["Names"].unique(), ordered=True)

result = (
    input.melt(
        id_vars=["Names"], 
        var_name="Custom", 
        value_name="Value"
    )
    .loc[
        lambda df: df.index.repeat(
            df["Value"].fillna(0).astype(int)
        )
    ]
    .drop(columns=["Value"])
    .sort_values(["Names", "Custom"])
    .reset_index(drop=True)
)

result["Names"] = result["Names"].astype(str)

print(result.equals(test))