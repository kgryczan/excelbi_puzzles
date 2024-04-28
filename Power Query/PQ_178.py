import pandas as pd

input = pd.read_excel("PQ_Challenge_178.xlsx", usecols = "A:E", nrows=5)
test = pd.read_excel("PQ_Challenge_178.xlsx", usecols="H:K", nrows=5, names=["Emp", "Change", "Old", "New"])
test = test.sort_values(by = ["Emp", "Change"]).reset_index(drop=True)

result = input.melt(id_vars="Emp", var_name="Change", value_name="Value")
result[["Type", "Change"]] = result["Change"].str.split(" ", expand=True) 
result = result.pivot(index=["Emp", "Change"], columns="Type", values="Value").dropna().reset_index()
result = result[["Emp", "Change", "Old", "New"]] 
result.columns.name = None
result = result.sort_values(by=["Emp", "Change"]).reset_index(drop=True)

print(result.equals(test)) # True