import pandas as pd

path = "681 Split and Align.xlsx"
input = pd.read_excel(path, usecols="A", nrows=4)
test = pd.read_excel(path, usecols="C:G", nrows=11, names=["1", "2", "3", "4", "5"])

input["RowNumber"] = input.index + 1
input = input.assign(**{"Split": input["Data"].str.split(", ")}).explode("Split")
input["row"] = range(1, len(input) + 1)
input["col"] = input.groupby("RowNumber").cumcount() + 1
input = input.pivot(index="row", columns="col", values="Split").reset_index(drop=True)
input.columns.name = None
input.columns = test.columns


print(test.equals(input)) # True