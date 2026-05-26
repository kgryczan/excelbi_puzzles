import pandas as pd
import numpy as np

path = "900-999/985/985 Countries and Capital Alignments.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=37, skiprows=1)
test = pd.read_excel(path, usecols="D:G", nrows=12, skiprows=1).pipe(lambda d: d.set_axis(d.columns.str.replace(r"\.1$", "", regex=True), axis=1))

result = (
    input.assign(Continent=lambda x: x["Continent"].ffill())
    .assign(n=lambda x: pd.to_numeric(x["Data"], errors="coerce").notna().groupby(x["Continent"]).transform("sum"))
    .assign(
        index=lambda x: x.groupby("Continent").cumcount() % x["n"] + 1,
        group=lambda x: x.groupby("Continent").cumcount() // x["n"] + 1
    )
    .assign(group=lambda x: x["group"].map({1: "Countries", 2: "Capital", 3: "GDP"}))
    .pivot(index=["Continent", "index"], columns="group", values="Data")
    .reset_index()
    .assign(
        Continent=lambda x: pd.Categorical(
            x["Continent"],
            categories=["Asia", "Americas", "Eurpoe"],
            ordered=True,
        ),
        GDP=lambda x: pd.to_numeric(x["GDP"]),
    )
    .sort_values(["Continent", "index"])
    .assign(Continent=lambda x: x["Continent"].astype(str))
    .reset_index(drop=True)
    [["Continent", "Countries", "Capital", "GDP"]]
)

print(result.equals(test))