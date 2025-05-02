import pandas as pd

input = pd.read_excel("450 Ranking.xlsx",  usecols="A:C", nrows=20)
test = pd.read_excel("450 Ranking.xlsx", usecols="D:D", nrows=20)

input["rank"] = input.groupby("Company")["Sales"].rank(method="dense", ascending=False)

print(input["rank"].equals(test["Answer Expected"])) # True