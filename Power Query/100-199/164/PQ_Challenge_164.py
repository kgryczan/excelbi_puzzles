import pandas as pd

input_data = pd.read_excel("PQ_Challenge_164.xlsx", usecols="A:E", nrows=7)
test = pd.read_excel("PQ_Challenge_164.xlsx", usecols="G:J", nrows=13)

result = input_data.melt(id_vars="Group", var_name="name", value_name="Value")
parts = result["name"].str.extract(r"(\D+)(\d+)")
result["base"] = parts[0]
result["suffix"] = parts[1]
result = result.pivot(index=["Group", "suffix"], columns="base", values="Value").reset_index(drop=True)
result["Type"] = result["Number"].str.findall(r"[A-Z]+").str.join("")
result["Code"] = result["Number"].str.findall(r"\d+").str.join("")
result = result[["Group", "Type", "Code", "Value"]]

print(result.equals(test))
