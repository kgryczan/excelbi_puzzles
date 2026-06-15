import pandas as pd

path = "900-999/999/999 Joined Cells.xlsx"
input = pd.read_excel(path, usecols="A", nrows=27)
test = pd.read_excel(path, usecols="B", nrows=5)

group = (input["Code"].str[0] != input["Code"].str[-1].shift()).cumsum()
input["Answer Expected"] = (
    input["Code"]
    .where(group.ne(group.shift()), input["Code"].str[-1])
    .groupby(group)
    .transform("sum")
)
input = input[["Answer Expected"]].drop_duplicates().reset_index(drop=True)
print(input.equals(test))
# True
