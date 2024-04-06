import pandas as pd

input = pd.read_excel("PQ_Challenge_171.xlsx", usecols="A:F", nrows = 6)
test  = pd.read_excel("PQ_Challenge_171.xlsx", usecols="H:I", nrows = 15)
test = test.rename(columns = {"Col1.1": "Col1", "Col2.1": "Col2"})

input["M"] = list(zip(zip(input["Col1"], input["Col4"]), zip(input["Col2"], input["Col5"]), zip(input["Col3"], input["Col6"])))
input = input.explode("M")
input = input.pop("M").apply(pd.Series).reset_index(drop=True)
input.columns = ["Col1", "Col2"]
input = input.dropna(subset=["Col1", "Col2"], how="all").reset_index(drop=True)

print(test.equals(input)) # True    