import pandas as pd
import re

input = pd.read_excel("PQ_Challenge_175.xlsx",  usecols="A:C", nrows=15)
test = pd.read_excel("PQ_Challenge_175.xlsx", usecols="E:H", nrows=19)
test["Relantionship"] = test["Relantionship"].str.replace(" ", "")
test.columns = ["Name", "Family", "Next Generation", "Relantionship"]

result = pd.merge(input, input, left_on="Family", right_on="Family")
result = result[result["Generation No_x"] == result["Generation No_y"] - 1]
result["Relantionship"] = result["Generation No_x"].astype(str) + "-" + result["Generation No_y"].astype(str)
result = result[["Name_x", "Family", "Name_y", "Relantionship"]].rename(columns={"Name_x": "Name", "Name_y": "Next Generation"})
result = result.sort_values(by=["Family", "Relantionship", "Name", "Next Generation"]).reset_index(drop=True)

print(result.equals(test)) # True