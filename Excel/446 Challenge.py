import pandas as pd
import numpy as np

input = pd.read_excel("446 Top 3 Min Distance.xlsx", usecols = "A:H", nrows=7)
test = pd.read_excel("446 Top 3 Min Distance.xlsx",  usecols="J:M", nrows=4, skiprows=1)

result = input.melt(id_vars="Cities", var_name="City 2", value_name="Distance")
result = result[result["Distance"] != 0]
result["Cities"] = result["Cities"] + " - " + result["City 2"]
result.drop(columns=["City 2"], inplace=True)
result["Cities"] = result["Cities"].str.split(" - ")
result["Cities"] = result["Cities"].apply(sorted)
result["Cities"] = result["Cities"].apply(lambda x: " - ".join(x))
result = result.drop_duplicates(subset="Cities")
result["rank"] = result["Distance"].rank(method="dense").astype("int64")
result = result[result["rank"] <= 3]
result = result.sort_values(["rank", "Cities"])
result["Cities"] = result["Cities"].str.split(" - ")
result["From City"] = result["Cities"].apply(lambda x: x[0])
result["To City"] = result["Cities"].apply(lambda x: x[1])
result = result[["rank", "From City", "To City", "Distance"]].reset_index(drop=True)    
result.columns = test.columns

print(result.equals(test)) # True