import pandas as pd

path = "Excel/900-999/915/915 Missing Invoice Numbers.xlsx"
input = pd.read_excel(path, usecols="A", nrows=24)
test = pd.read_excel(path, usecols="B", nrows=12).sort_values(by="Answer Expected").reset_index(drop=True)

input[['prefix', 'number']] = input['Invoice_ID'].str.split('-', expand=True)
input['number'] = input['number'].astype(int)

full = (
    input.groupby("prefix")["number"]
    .apply(lambda x: pd.Series(range(x.min(), x.max() + 1)))
    .reset_index()
    .rename(columns={"level_1": "idx", 0: "number"})
    .drop(columns="idx")
)

result = (
    full.merge(input, on=["prefix", "number"], how="left")
    .loc[lambda x: x["Invoice_ID"].isna(), ["prefix", "number"]]
    .assign(Invoice_ID=lambda x: x["prefix"] + "-" + x["number"].astype(str))
    [["Invoice_ID"]]
    .reset_index(drop=True)
)

print(result["Invoice_ID"].equals(test["Answer Expected"]))
