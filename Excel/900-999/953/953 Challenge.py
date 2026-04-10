import pandas as pd

path = "900-999/953/953 Streak Identification.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=23, skiprows=1)
test = pd.read_excel(path, usecols="E:G", nrows=4, skiprows=1).rename(columns={"MachineID.1": "MachineID"})

result = input.copy()
result["group"] = (
	result["MachineID"]
	.ne(result["MachineID"].shift(fill_value=result["MachineID"].iloc[0]))
	.cumsum()
)
value_prev = result.groupby("group")["Value"].shift(1)
value_next = result.groupby("group")["Value"].shift(-1)
result["active"] = (
	(result["Value"] >= 80)
	| ((result["Value"] < 80) & (value_prev >= 80) & (value_next >= 80))
)
result = result[result["active"]].copy()
result["subgroup"] = (
	(result["TimeID"] - result["TimeID"].shift(fill_value=result["TimeID"].iloc[0]) != 1)
	.cumsum()
)
result["StartID"] = result.groupby(["group", "subgroup"])["TimeID"].transform("min")
result["EndID"] = result.groupby(["group", "subgroup"])["TimeID"].transform("max")
result = result[["MachineID", "StartID", "EndID"]].drop_duplicates().reset_index(drop=True)

print(result.equals(test))
# Output: True