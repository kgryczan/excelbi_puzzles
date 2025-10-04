import pandas as pd

path = "300-399/327/PQ_Challenge_327.xlsx"
input = pd.read_excel(path, header=None, usecols="A:E", skiprows=1, nrows=20)
test = pd.read_excel(path, usecols="G:H", skiprows=1, nrows=5)

df = input[~input[0].astype(str).str.contains("Shipment Month", na=False)].copy()
df["block"] = df[0].astype(str).str.contains("Date", na=False).cumsum()

def tidy(g):
    g = g.drop(columns="block").reset_index(drop=True)
    g.columns = g.iloc[0]
    return g.iloc[1:].melt(id_vars="Date", var_name="Vegetables", value_name="Sales")

long = pd.concat([tidy(g) for _, g in df.groupby("block")], ignore_index=True)

result = (
    long.assign(Sales=pd.to_numeric(long.Sales, errors="coerce"))
        .dropna(subset=["Sales"])
        .groupby("Vegetables", as_index=False)["Sales"].sum()
        .rename(columns={"Sales": "Amount"})
        .sort_values("Amount", ascending=False)
        .reset_index(drop=True)
)
result["Amount"] = result["Amount"].astype(int)

print(result.equals(test)) #True
