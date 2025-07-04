import pandas as pd

path = "700-799/753/753 Pivot on Years.xlsx"

input = pd.read_excel(path, usecols="A", skiprows=1, nrows=5)
test = pd.read_excel(path, usecols="C:H", skiprows=1, nrows=5).sort_values(by="Name").reset_index(drop=True)


result = (
    input["Data"]
    .str.split(" : |, |-", expand=True)
    .rename(columns={0: "Name", 1: "Year", 2: "Value"})
    .ffill()
    .pivot_table(index="Name", columns="Year", values="Value", aggfunc="sum")
    .reset_index()
)
result.columns = test.columns

print(result.equals(test))
