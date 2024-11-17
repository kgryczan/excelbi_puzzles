import pandas as pd

path = "PQ_Challenge_236.xlsx"

input = pd.read_excel(path, usecols="A:F", nrows=4)
test = pd.read_excel(path, usecols="I:J", nrows=16)

result = input.melt(var_name="Data1", value_name="Data2").dropna()
result["Count"] = result.groupby("Data2").cumcount() + 1
result = result[~((result["Count"] == 2) & (result["Data1"] == "Hall"))]
result = result.drop(columns="Count").reset_index(drop=True)

print(result.equals(test))    # True
