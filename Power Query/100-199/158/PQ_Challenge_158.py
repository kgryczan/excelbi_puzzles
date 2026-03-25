import pandas as pd

input_data = pd.read_excel("PQ_Challenge_158.xlsx", usecols="A:K", nrows=5)
test = pd.read_excel("PQ_Challenge_158.xlsx", usecols="A:G", skiprows=9, nrows=8).astype(str)

long = input_data.melt(id_vars=input_data.columns[0], var_name="variable", value_name="value")
long["variable"] = long["variable"].where(long["variable"].astype(str).str.startswith("D"))
long["variable"] = long["variable"].ffill()
dept = long.columns[0]
headers = long.loc[long[dept] == "Group", "value"].tolist()

result = long.loc[long[dept] != "Group"].copy()
result["headers"] = headers * (len(result) // len(headers))
result = result.pivot(index=[dept, "variable"], columns="headers", values="value").reset_index()
result = result[result["Emp ID"].notna()].rename(columns={dept: "Group", "variable": "Dept"})
result = result.astype(str)

print(result.equals(test))
