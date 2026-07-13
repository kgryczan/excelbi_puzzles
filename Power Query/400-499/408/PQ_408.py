import pandas as pd

path = "400-499/408/PQ_Challenge_408.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=21)
test = pd.read_excel(path, usecols="E:F", nrows=3)

result = (
    input.join(
        input.pop("Data")
        .str.split(";", expand=True)
        .set_axis(["Quantity", "LocalPrice", "Currency", "Status"], axis=1)
    )
    .astype({"Quantity": float, "LocalPrice": float})
    .assign(
        USD=lambda x: x.LocalPrice * x.Currency.map({"EUR": 1.1, "GBP": 1.3}).fillna(1)
    )
    .query("Status == 'Completed'")
    .sort_values(["Category", "Date"])
    .groupby("Category")
    .tail(3)
    .assign(wx=lambda x: x.Quantity * x.USD)
    .groupby("Category", as_index=False)
    .agg(**{"Weighted Avg USD": ("wx", "sum"), "Quantity": ("Quantity", "sum")})
    .assign(**{"Weighted Avg USD": lambda x: x["Weighted Avg USD"] / x.Quantity})
    .drop(columns="Quantity")
)

# Only one value matches
