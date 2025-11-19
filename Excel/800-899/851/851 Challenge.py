import pandas as pd

path = "Excel/800-899/851/851_Excel_Challenge.xlsx"
input = pd.read_excel(path, usecols="A", skiprows=1, nrows=18)
test = pd.read_excel(path, usecols="C:F", skiprows=1, nrows=4)

input["col1"] = input["Data"].where((input.index == 0) | (input["Data"].shift(1) == "==============="))
input["col1"] = input["col1"].ffill()
filtered = input[(input["Data"] != "===============") & (input["col1"] != input["Data"])].reset_index(drop=True)
filtered = filtered.sort_values(["col1", "Data"])
filtered["rn"] = filtered.groupby("col1").cumcount() + 1
result = filtered.pivot(index="rn", columns="col1", values="Data")
result = result.reset_index(drop=True)

print(result.equals(test)) # True