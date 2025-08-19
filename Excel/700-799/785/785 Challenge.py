import pandas as pd

path = "700-799/785/785 Pivot.xlsx"
input = pd.read_excel(path, usecols="A", skiprows=1, nrows=5)
test = pd.read_excel(path, usecols="C:F", skiprows=1, nrows=5).assign(**{col: lambda df, c=col: pd.to_numeric(df[c], errors="coerce").astype('Int64') for col in ["Revenue", "Cost", "Profit"]})

input_long = input["Data"].str.split(", ", expand=True).stack().str.split(":", n=1, expand=True)
input_long[1] = input_long[1].str.strip()
input_long = input_long.reset_index(level=1, drop=True)
input_long.columns = ["Variable", "Value"]
input_long["group"] = (input_long["Variable"] == "Org").cumsum()

result = input_long.pivot(index="group", columns="Variable", values="Value").reset_index(drop=True)
for col in ["Revenue", "Cost", "Profit"]:
    result[col] = pd.to_numeric(result[col], errors="coerce").astype('Int64')

result["Revenue"].fillna(result["Cost"] + result["Profit"], inplace=True)
result["Cost"].fillna(result["Revenue"] - result["Profit"], inplace=True)
result["Profit"].fillna(result["Revenue"] - result["Cost"], inplace=True)
result = result[["Org", "Revenue", "Cost", "Profit"]]
result.columns.name = None

print(result.equals(test)) # True
