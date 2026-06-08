import pandas as pd

path = "900-999/994/994 Housing Prices.xlsx"
input = pd.read_excel(path, usecols="A:D", nrows=23, skiprows=1)
test = pd.read_excel(path, usecols="F:G", nrows=5, skiprows=1).rename(
    columns=lambda c: c.replace(".1", "") if isinstance(c, str) else c
)

result = (
    input.groupby("City", as_index=False)
    .apply(
        lambda g: pd.Series(
            {
                "Volatility": g["Price"].max() - g["Price"].min(),
                "Latest_Price": g.loc[
                    g["ListDate"] == g["ListDate"].max(), "Price"
                ].median(),
            }
        )
    )
    .reset_index(drop=True)
)
result["Adjustment"] = 0.0
result.loc[result["Volatility"] >= 5e5, "Adjustment"] = 0.01
result.loc[result["Volatility"] >= 1e6, "Adjustment"] = 0.02
result["FinalMarketPrice"] = (
    result["Latest_Price"] * (1 - result["Adjustment"])
).astype("int64")
result = result[["City", "FinalMarketPrice"]].sort_values("City").reset_index(drop=True)

print(result.equals(test))
