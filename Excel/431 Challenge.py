import pandas as pd

input = pd.read_excel("431 Top 3 Rankings.xlsx", usecols="A:H", nrows=20)
test = pd.read_excel("431 Top 3 Rankings.xlsx",  usecols="J:K", nrows=3, skiprows=1)

result = input.melt(id_vars=["Region"], var_name="year", value_name="result")
result["Rank"] = result.groupby("year")["result"].rank("dense", ascending=False).astype('int64')
result = result[result["Rank"] <= 3]
result = result.groupby(["Region", "Rank"]).size().reset_index(name="n")
result = result.groupby("Rank").apply(lambda x: x[x["n"] == x["n"].max()]).reset_index(drop=True)
result["RegionNo"] = result["Region"].str.extract(r"(\d+)").astype(int)
result = result.sort_values(["Rank", "RegionNo"])

result = result.groupby("Rank")["Region"].apply(lambda x: ", ".join(x)).reset_index(name="Regions")

print(result.equals(test))