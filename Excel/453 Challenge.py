import pandas as pd

input = pd.read_excel("453 Common in Columns.xlsx", sheet_name="Sheet1", usecols="A:B")
test = pd.read_excel("453 Common in Columns.xlsx", sheet_name="Sheet1", usecols="D:E", skiprows=1, nrows = 4)

result = input.assign(nr_l1=input.groupby("List1").cumcount()+1).assign(nr_l2=input.groupby("List2").cumcount()+1)
result["List1"] = result["List1"] + "_" + result["nr_l1"].astype(str)
result["List2"] = result["List2"] + "_" + result["nr_l2"].astype(str)

l1 = result["List1"].tolist()
l2 = result["List2"].tolist()

common = list(set(l1) & set(l2))

result2 = pd.DataFrame(common, columns=["Match"])
result2[["Match", "Count"]] = result2["Match"].str.split("_", expand=True)
result2["Count"] = result2["Count"].astype("int64")
result2 = result2.groupby("Match")["Count"].max().reset_index()

print(result2.equals(test)) # True