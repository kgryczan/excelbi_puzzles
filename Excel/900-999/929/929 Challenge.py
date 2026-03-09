import pandas as pd

path = "900-999/929/929 Delivered Shipments.xlsx"
input = pd.read_excel(path, usecols="A", header=1, nrows=20)
test = pd.read_excel(path, usecols="C:E", header=1, nrows=5)

result = (
    input["Data"].str.split("_", expand=True)
    .set_axis(["Date", "Truck ID", "Status", "Revenue"], axis=1)
    .assign(
        Revenue=lambda df: pd.to_numeric(df["Revenue"].str.replace(r"[^\d.]", "", regex=True)),
        Date=lambda df: pd.to_datetime(df["Date"])
    )
    .query("Status == 'DELIVERED'")
    .groupby("Truck ID", as_index=False)
    .agg(**{
        "Total Revenue": ("Revenue", lambda x: f"${x.sum():,.2f}"),
        "Last Delivery Date": ("Date", "max")
    })
    .sort_values("Truck ID", key=lambda s: s.str.extract(r'(\d+)', expand=False).astype(int))
    [["Truck ID", "Total Revenue", "Last Delivery Date"]]
    .reset_index(drop=True)
)

print(result.equals(test))
# True