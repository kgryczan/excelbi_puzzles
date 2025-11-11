import pandas as pd

path = "Excel/800-899/845/845 Employee Groups.xlsx"
input = pd.read_excel(path, usecols="A:C", skiprows=1, nrows=13)
test = pd.read_excel(path, usecols="E:G", skiprows=1, nrows=5).rename(columns=lambda c: c.replace(".1", ""))\
    .assign(Name=lambda df: df["Name"].str.replace(r" , ", ", ", regex=True))

result = (
    input.groupby(["Dept ID", "Emp Ind"], as_index=False)["Name"]
    .agg(", ".join)
    .sort_values(["Dept ID", "Emp Ind"])
)[["Dept ID", "Name", "Emp Ind"]]

print(result.equals(test))  # True