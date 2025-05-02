import pandas as pd

input = pd.read_excel("433 Text Split.xlsx", usecols="A", nrows=20)
test  = pd.read_excel("433 Text Split.xlsx", usecols="C:G", nrows=20)

input[["numbers", "names"]] = input["Text"].str.split(" : ", expand=True)
input[["Level1","Level2", "Level3"]] = input["numbers"].str.split(".", expand=True).apply(pd.to_numeric)
input[["First Name", "Last Name"]] = input["names"].str.split(" ", expand=True)
input = input.drop(columns=["Text", "numbers", "names"])

print(input.equals(test))