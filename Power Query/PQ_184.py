import pandas as pd
import re

input = pd.read_excel("PQ_Challenge_184.xlsx", usecols="A:B", nrows = 9)
test = pd.read_excel("PQ_Challenge_184.xlsx", usecols="D:G", nrows = 3) 
test.columns = test.columns.str.replace(".1", "")

input["group"] = input["Text"].str.findall("[A-Za-z]+\\d+")
input["group"] = input["group"].apply(lambda x: x[-1] if len(x) > 1 else x[0] if len(x) == 1 else None)

result = input.groupby("Set").agg(
    Text=("group", lambda x: "-".join([group for group in x if group])),
    Original_Count=("group", "size"),
    New_Count=("group", lambda x: x.notnull().sum())).rename(columns={"Original_Count": "Original Count",
                  "New_Count": "New Count"}).reset_index()

print(result.equals(test)) # True