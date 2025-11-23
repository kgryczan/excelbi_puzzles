import pandas as pd

path = "Power Query/300-399/341/PQ_Challenge_341.xlsx"
input = pd.read_excel(path,  usecols="A:D", nrows=11)
test = pd.read_excel(path, usecols="G:K", nrows=11).rename(columns=lambda x: x.rstrip())

input_t = input.T
input_t["Dept"] = input_t.index
input_long = input_t.reset_index(drop=True).melt(id_vars="Dept", var_name="col", value_name="score")

input_long["col"] = input_long["col"].astype(str)
input_long["col_group"] = input_long["col"].str.extract(r"(\d+)").astype(int)  // 2

input_long["rn"] = input_long.groupby(["Dept", "col_group"]).cumcount()

pivoted = input_long.pivot_table(
    index=["Dept", "col_group"],
    columns="rn",
    values="score",
    aggfunc="first"
).reset_index()

pivoted = pivoted.drop(columns="col_group")
pivoted = pivoted.rename(columns={0: "Employee", 1: "data"})
data_split = pivoted["data"].str.split(", ", expand=True)
data_split.columns = ["Age", "Nationality", "Salary"]

data_split["Age"] = pd.to_numeric(data_split["Age"], errors="coerce")
data_split["Salary"] = pd.to_numeric(data_split["Salary"], errors="coerce")

pivoted = pd.concat([pivoted.drop(columns="data"), data_split], axis=1)
pivoted = pivoted.drop_duplicates()

pivoted = pivoted.sort_values(by=["Dept", "Employee"]).reset_index(drop=True)
test = test.sort_values(by=["Dept", "Employee"]).reset_index(drop=True)

print(pivoted.equals(test)) # True