import pandas as pd

path = "900-999/959/959  SKU Pairing.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=35, skiprows=1)
test = pd.read_excel(path, usecols="D:F", nrows=21, skiprows=1)

cooc = (
    input.merge(input, on="TxnID", suffixes=("", ".1"))
         .groupby(["SKU", "SKU.1"])
         .size()
         .reset_index(name="n")
)
cooc = cooc[cooc["SKU"] < cooc["SKU.1"]].reset_index(drop=True)
cooc.columns = test.columns

print(cooc.equals(test))
# True