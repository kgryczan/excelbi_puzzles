import pandas as pd
import re
input = pd.read_excel("433 Text Split.xlsx", usecols="A", nrows=20)
test  = pd.read_excel("433 Text Split.xlsx", usecols="C:G", nrows=20)

pattern = "(\\d+)(\\.\\d+)?(\\.\\d+)?\\s*:\\s*(\\w+)\\s+(\\w+)"
input[["Level1", "Level2", "Level3", "First Name", "Last Name"]] = input["Text"].str.extract(pattern)
input[["Level2", "Level3"]] = input[["Level2", "Level3"]].replace({"\.": ""}, regex=True).apply(pd.to_numeric)
input[["Level1"]] = input[["Level1"]].astype("int64")
input = input.drop(columns=["Text"])

print(input.equals(test)) # True
