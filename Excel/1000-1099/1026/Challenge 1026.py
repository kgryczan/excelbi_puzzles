import pandas as pd

path = "1000-1099/1026/1026 Grouped Mail IDs.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=18, skiprows=1)
test = pd.read_excel(
    path, usecols="E:F", nrows=6, skiprows=1, names=["Customer", "Canonical Email"]
)

result = (
    input.assign(Email=input["Email"].str.lower())
    .loc[
        lambda df: ~(
            df["Email"].str.endswith("@gmail.com")
            & df["Email"].str.split("@").str[0].str.contains(r"\+")
        )
    ]
    .drop_duplicates(["Customer", "Email"])
    .groupby("Customer", as_index=False)
    .agg(**{"Canonical Email": ("Email", ", ".join)})
)

print(result.equals(test))
# True
