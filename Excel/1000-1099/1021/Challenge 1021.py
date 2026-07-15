import pandas as pd

path = "1000-1099/1021/1021 Expansion.xlsx"
input = pd.read_excel(path, usecols="A:D", nrows=3, skiprows=1)
test = pd.read_excel(path, usecols="F:I", nrows=27, skiprows=1)
test.columns = input.columns

result = (
    input.melt(id_vars="Emp", var_name="col", value_name="n")
    .dropna()
    .loc[lambda x: x.index.repeat(x["n"].astype("int64"))]
    .assign(i=lambda x: x.groupby(["Emp", "col"]).cumcount() + 1)
    .assign(
        cont=lambda x: x["col"] * x["i"], nr=lambda x: x.groupby("Emp").cumcount() + 1
    )
    .drop(columns="i")
    .pivot(index=["Emp", "nr"], columns="col", values="cont")
    .reset_index()
    .drop(columns="nr")
    .rename_axis(columns=None)
    .reindex(columns=input.columns)
)
print(result.equals(test))
# True
