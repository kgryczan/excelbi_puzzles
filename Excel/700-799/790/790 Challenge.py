import pandas as pd

path = "700-799/790/790 Pivot.xlsx"
input = pd.read_excel(path, usecols="A", skiprows=1, nrows=11)
test = pd.read_excel(path, usecols="C:F", skiprows=1, nrows=4).fillna({"Age":0,"Department":""}).sort_values(["Age","Department"]).reset_index(drop=True)

input["Name"] = input["Data"].str.extract(r"Name: (.*)").ffill()
input[["Key", "Value"]] = input["Data"].str.split(": ", n=1, expand=True)
result = input[input["Name"] != input["Value"]].pivot(index="Name", columns="Key", values="Value").reset_index()
result = result.assign(Department=result["Department"].str.split(" \| ")).explode("Department")
result = result[["Name", "Salary", "Age", "Department"]].fillna({"Age":0,"Salary":0,"Department":""})
result["Age"] = result["Age"].astype(float)
result["Salary"] = result["Salary"].astype(int)
result = result.sort_values(["Age","Department"]).reset_index(drop=True)
result.columns.name = None

print(result.equals(test)) # True
