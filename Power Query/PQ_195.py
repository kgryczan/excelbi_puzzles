import pandas as pd
import re

def split_string(s):
    return re.split(r"\W+", str(s))

path = "PQ_Challenge_195.xlsx"
input1 = pd.read_excel(path, usecols="A:C", nrows=5)
input2 = pd.read_excel(path, usecols="A:B", skiprows=7, nrows=3)
test = pd.read_excel(path, usecols="F:G", nrows=3)

input1 = pd.concat([input1[col].apply(split_string).explode().reset_index(drop=True) for col in input1.columns], axis=1)

input2["Items"] = input2["Items"].apply(split_string)
input2 = pd.DataFrame(input2["Items"].explode()).\
    merge(input2, left_index=True, right_index=True).\
    drop(columns=["Items_y"]).rename(columns={"Items_x": "Items"})
input2["Stockist_no"] = input2.groupby("Items")["Stockist"].transform("count")
input2 = pd.merge(input1, input2, on="Items", how="right").dropna().reset_index(drop=True)
input2["Amount Paid"] = (input2["Unit Price"].astype(int) * input2["Quantity"].astype(int)) / input2["Stockist_no"]
input2["Amount Paid"] = input2["Amount Paid"].astype("int64")

result = input2.groupby("Stockist")["Amount Paid"].sum().reset_index()

print(result.equals(test)) # True