import pandas as pd

path = "300-399/397/PQ_Challenge_397.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=30, skiprows=0)
test = pd.read_excel(path, usecols="E:F", nrows=2, skiprows=0)

owner = {t: t for t in input["Territory"].unique()}

for _, g in input.groupby("Month", sort=False):
    win = g.loc[g["Revenue"].idxmax(), "Territory"]
    lose = g.loc[g["Revenue"].idxmin(), "Territory"]

    old, new = owner[lose], owner[win]
    owner = {t: new if o == old else o for t, o in owner.items()}

output = (
    pd.Series(owner, name="Owner")
    .rename_axis("Territory")
    .reset_index()
    .groupby("Owner", sort=False)["Territory"]
    .agg(", ".join)
    .reset_index(name="Territories")
)
print(output.equals(test))
# True