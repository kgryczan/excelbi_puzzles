import pandas as pd

path = "900-999/993/993 Pivot.xlsx"
input = pd.read_excel(path, usecols="A", nrows=21)
test = pd.read_excel(path, usecols="C:D", nrows=6, skiprows=1)

priority_w = {"H": .5, "M": .3, "L": .1}
channel_w  = {"E": .4, "P": .2, "C": .1}
currency_fx = {"USD": 94, "EUR": 130, "INR": 1}

out = (
    input["Data"]
    .str.extract(
        r"LOC\((?P<City>[^)]+)\)-TX\{[^|]+\|(?P<Currency>[A-Z]{3})\|(?P<Amount>\d+)\|[^}]+\}"
    )
    .join(input["Data"].str.extract(r"\bP:(?P<Priority>[HML])\b"))
    .join(input["Data"].str.extract(r"\bC:(?P<Channel>[EPC])\b"))
    .assign(
        Amount=lambda x: pd.to_numeric(x["Amount"], errors="coerce").fillna(0).astype("int64"),
        Weighted=lambda x: (
            x["Amount"]
            * x["Currency"].map(currency_fx).fillna(0)
            * (
                x["Priority"].map(priority_w).fillna(0)
                + x["Channel"].map(channel_w).fillna(0)
            )
        ).round().astype("int64")
    )
    .groupby("City", as_index=False)["Weighted"]
    .sum()
    .rename(columns={"Weighted": "Weighted Total (INR)"})
    .sort_values("City")
)

print(out == test)
# One Value is different. 