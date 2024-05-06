import pandas as pd

input = pd.read_excel("PQ_Challenge_180.xlsx", sheet_name="Sheet1", usecols="A:B")
test = pd.read_excel("PQ_Challenge_180.xlsx", sheet_name="Sheet1", usecols="D:G", nrows=3)

input["Emp"] = input["Emp-Month"].where(input["Sales"].isnull()).ffill()
input = input.dropna(subset=["Sales"]).astype({"Sales": "int64"})
input["Total"] = input.groupby("Emp")["Sales"].transform("sum")
input[["Prev", "Prev_month"]] = input.groupby("Emp")[["Sales", "Emp-Month"]].shift(1)
input["Diff"] = abs(input["Sales"] - input["Prev"]).fillna(0).astype("int64")
input = input.loc[input.groupby("Emp")["Diff"].idxmax()]
input["From - To Months"] = input["Prev_month"] + " - " + input["Emp-Month"]
input = input.drop(columns=["Prev", "Prev_month", "Sales", "Emp-Month"]).reset_index(drop=True)
input.columns = test.columns

print(input.equals(test)) # True
