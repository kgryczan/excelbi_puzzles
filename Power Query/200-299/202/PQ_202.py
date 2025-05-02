import pandas as pd

path = "PQ_Challenge_202.xlsx"
input = pd.read_excel(path, usecols="A:C")
test = pd.read_excel(path, usecols="E:F")

result = input.copy()
result["L1"] = result["Name1"].notna().cumsum()
result["L2"] = result.groupby("L1")["Name2"].transform(lambda x: x.notna().cumsum())
result["L3"] = result.groupby(["L1", "L2"])["Name3"].transform(lambda x: x.notna().cumsum())

result[["L1", "L2", "L3"]] = result[["L1", "L2", "L3"]].astype("Int64").astype(str).replace("0", pd.NA)
result["Names"] = result["Name3"].combine_first(result["Name2"]).combine_first(result["Name1"])
result["Serial"] = result[["L1", "L2", "L3"]].apply(lambda x: ".".join(x.dropna()), axis=1)
result = result[["Serial", "Names"]]

print(result.equals(test)) # True