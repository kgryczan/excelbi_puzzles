import pandas as pd

path = "900-999/934/934 Top Two.xlsx"
input = pd.read_excel(path, usecols="A:D", skiprows=1, nrows=25)
test = pd.read_excel(path, usecols="F:G", skiprows=1, nrows=4)

result = (
    input.groupby(["EmployeeID", "ProjectID"], as_index=False)["Hours"].sum()
    .groupby("ProjectID", group_keys=False)
    .apply(lambda x: x.nlargest(2, "Hours", keep="all"))
    .groupby("ProjectID")["EmployeeID"]
    .apply(lambda x: ", ".join(x.astype(str)))
    .reset_index(name="Top 2")
)

print(result.equals(test))
# Difference in Project Alpha
