import pandas as pd

input_data = pd.read_excel("PQ_Challenge_143.xlsx", usecols="A:C", nrows=21)
test = pd.read_excel("PQ_Challenge_143.xlsx", usecols="F:H", nrows=7)

result = input_data.copy()
result["rn"] = result.groupby(["Emp", "Value"]).cumcount() + 1
group_sizes = result.groupby(["Emp", "Value"])["rn"].transform("max")
result = result[(result["rn"] == 2) | ((result["rn"] == group_sizes) & (result["rn"] > 2))].drop(columns="rn").reset_index(drop=True)

print(result.equals(test))
