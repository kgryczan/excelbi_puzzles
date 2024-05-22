import pandas as pd

input = pd.read_excel("461 Sort the Numbers.xlsx", usecols="A", nrows = 9)
test = pd.read_excel("461 Sort the Numbers.xlsx", usecols="B", nrows = 9)

input[["A","B","C","D"]] = input["String"].str.split(".", expand=True).apply(pd.to_numeric)
input = input.sort_values(by=["A","B","C","D"])
result = input["String"].reset_index(drop=True)

print(result.equals(test["Answer Expected"])) # True