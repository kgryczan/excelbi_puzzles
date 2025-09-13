import pandas as pd

path = "300-399/321/PQ_Challenge_321.xlsx"

input = pd.read_excel(path, usecols="A:G", nrows=8)
test = pd.read_excel(path, usecols="K:P", nrows=4).fillna("").rename(columns=lambda c: c.replace(".1", ""))

id_cols = [col for col in input.columns if col.startswith("ID")]
result = (
    input.groupby("Date")[id_cols]
    .agg(lambda x: ", ".join(x.dropna().astype(str)))
    .reset_index()
)

print(result.equals(test)) # True