import pandas as pd

path = "496 Sum Marks.xlsx"
input = pd.read_excel(path, usecols="A:B", skiprows=1, nrows = 5)
test = pd.read_excel(path, usecols="D:E", skiprows=1, nrows = 4)
test.columns = test.columns.str.replace(r"\.1", "", regex=True)

result = input["Subjects"].str.split(", ", expand=True).stack().reset_index(level=1, drop=True).rename("Subjects")
result = result.str.replace(r"\W", "", regex=True).str.extract(r"([a-zA-Z]+)(\d+)", expand=True)
result.columns = ["Subjects", "Marks"]
result["Marks"] = result["Marks"].astype("int64")
result = result.groupby("Subjects")["Marks"].sum().sort_index().reset_index().rename(columns={"Subjects": "Subjects", "Marks": "Total"})

print(result.equals(test)) # True