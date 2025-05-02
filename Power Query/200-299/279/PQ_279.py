import pandas as pd

path = "PQ_Challenge_279.xlsx"
input = pd.read_excel(path, usecols="A:E", nrows=8)
test = pd.read_excel(path, usecols="G:J", nrows=14).rename(columns=lambda x: x.rstrip('.1'))

df_long = pd.wide_to_long(input.reset_index(), ["Code", "Value"], ["Group", "index"], "idx", "", "\d+").reset_index()
df_long = df_long.dropna(subset=["Code", "Value"])
df_long[["Type", "Code"]] = df_long["Code"].str.extract(r"([A-Z]+)(\d+)")
result = df_long[["Group", "Type", "Code", "Value"]]
result["Value"] = result["Value"].astype(int)
result["Code"] = result["Code"].astype(int)

print(result.equals(test)) # True
