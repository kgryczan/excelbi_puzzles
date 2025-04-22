import pandas as pd

path = "700 Pivot Data.xlsx"
input = pd.read_excel(path, usecols="A", skiprows=1, nrows=5)
test = pd.read_excel(path, usecols="C:D", skiprows=1, nrows=9)

result = (
    input["Data"]
    .str.extractall(r"(\w+)-(\d+)")
    .rename(columns={0: "Alphabet", 1: "Value"})
    .astype({"Value": int})
    .groupby("Alphabet", as_index=False)["Value"]
    .sum()
)

r2 = pd.concat([result, pd.DataFrame([{"Alphabet": "TOTAL", "Value": result["Value"].sum()}])], ignore_index=True)

print(r2.equals(test))  # True