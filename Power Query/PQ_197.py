import pandas as pd

path = "PQ_Challenge_197.xlsx"

input = pd.read_excel(path, usecols="A:E")
test  = pd.read_excel(path, usecols="H:N")
test.columns = test.columns.str.replace(".1", "")

input["Month"] = pd.to_datetime(input["Month"], format="%b").dt.month
input = input.sort_values(["Store", "Item", "Month"]).reset_index(drop=True)
input["Row"] = input.groupby(["Store", "Item"]).cumcount()+1

for i in range(len(input)):
    if input.loc[i, "Row"] == 1:
        input.loc[i, "Start Stock"] = input.loc[i, "Stock IN"]
        input.loc[i, "End Stock"] = input.loc[i, "Stock IN"] - input.loc[i, "Stock OUT"]
    else:
        input.loc[i, "Start Stock"] = input.loc[i-1, "End Stock"]
        input.loc[i, "End Stock"] = input.loc[i, "Start Stock"] - input.loc[i, "Stock OUT"] + input.loc[i, "Stock IN"]

input["Month"] = pd.to_datetime(input["Month"], format="%m").dt.strftime("%b")
input["Start Stock"] = input["Start Stock"].astype("int64")
input["End Stock"] = input["End Stock"].astype("int64")

result = test.merge(input, on=["Store", "Item", "Month", "Stock IN"], how="left", suffixes=("_test", ""))
result = result[["Month","Item","Store",   "Stock IN", "Stock OUT", "Start Stock", "End Stock"]]

print(result.equals(test)) # True
