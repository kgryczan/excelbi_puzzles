import pandas as pd
import numpy as np

path = "Excel/900-999/909/909 Unpivot.xlsx"
input = pd.read_excel(path, usecols="A:D", skiprows=1, nrows=9)
test = pd.read_excel(path,  usecols="F:J", skiprows=1, nrows=13).rename(columns=lambda x: x.replace(".1", ""))

result = (
    input
    .assign(**{
        "Project Data": input["Project Data"].str.split("|")
    })
    .explode("Project Data")
    .assign(
        Project=lambda d: d["Project Data"].str.split(":").str[0],
        Hours=lambda d: pd.to_numeric(
            d["Project Data"].str.split(":").str[1],
            errors="coerce"
        )
    )
    .assign(
        Hours=lambda d: np.where(d["Hours"].isna() | (d["Hours"] < 10), 0, d["Hours"]),
        Project=lambda d: np.where(d["Hours"] == 0, "Bench", d["Project"])
    )
    .drop(columns="Project Data")
    .groupby(list(input.columns.drop("Project Data")) + ["Project"], as_index=False)
    .agg(Hours=("Hours", "sum")).astype({'Hours': 'int64'})
)
print(result.equals(test))
# True