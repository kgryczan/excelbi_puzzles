import pandas as pd

path = "1000-1099/1023/1023 Pivot.xlsx"

input = pd.read_excel(
    path, usecols="A", skiprows=1, nrows=27, header=None, names=["Data"]
)
test = pd.read_excel(path, usecols="C:H", skiprows=1, nrows=6)

data = input["Data"].str.split(",", n=1, expand=True)
data.columns = ["Property", "Value"]

headers = data.iloc[0].tolist()

data = data.iloc[1:].copy()
data["group"] = data["Property"].eq("EmployeeID").cumsum()

result = (
    data.pivot_table(
        index="group",
        columns="Property",
        values="Value",
        aggfunc=lambda x: ", ".join(x),
    )
)[["EmployeeID", "Name", "Skill", "Role", "Location", "Status"]].reset_index(drop=True)

print(result.equals(test))
# True
